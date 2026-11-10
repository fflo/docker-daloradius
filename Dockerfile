# PHP branch (or exact release) of the official image to build on.
# The branch tag follows the latest patch release, so rebuilding with
# `docker build --pull` picks up new PHP security releases.
ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-apache

# Refuse to build on a PHP release that predates the fixes for the
# October 2026 remote code execution advisories (CVE-2026-109618 and
# CVE-2026-109619). This catches stale, locally cached base images.
RUN php -r '$fixed = ["8.2" => "8.2.35", "8.3" => "8.3.36", "8.4" => "8.4.27", "8.5" => "8.5.12"]; $branch = PHP_MAJOR_VERSION . "." . PHP_MINOR_VERSION; if (version_compare(PHP_VERSION, "8.2.0", "<") || (isset($fixed[$branch]) && version_compare(PHP_VERSION, $fixed[$branch], "<"))) { fwrite(STDERR, "PHP " . PHP_VERSION . " lacks the fixes for CVE-2026-109618 and CVE-2026-109619. Rebuild with --pull or a newer PHP_VERSION.\n"); exit(1); }'

# Runtime tools: radclient (user connectivity tests and disconnects), ifconfig
# and top (server status page) and the MariaDB client (database setup and
# migrations on container start)
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        freeradius-utils \
        mariadb-client \
        net-tools \
        procps \
    ; \
    rm -rf /var/lib/apt/lists/*; \
# the daloRADIUS start script calls the client by its mysql names
    for tool in mysql:mariadb mysqladmin:mariadb-admin; do \
        if ! command -v "${tool%%:*}" > /dev/null; then \
            ln -s "$(command -v "${tool##*:}")" "/usr/local/bin/${tool%%:*}"; \
        fi; \
    done; \
    mysql --version; \
    mysqladmin --version

# PHP extensions used by daloRADIUS: gd, ldap and pdo_mysql
# (curl and mbstring are already part of the base image)
RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg-dev \
        libldap2-dev \
        libpng-dev \
    ; \
    debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-configure ldap --with-libdir="lib/$debMultiarch"; \
    docker-php-ext-install -j "$(nproc)" \
        gd \
        ldap \
        pdo_mysql \
    ; \
    extDir="$(php -r 'echo ini_get("extension_dir");')"; \
    [ -d "$extDir" ]; \
# remove the build dependencies again, keeping the libraries the extensions link to
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    ldd "$extDir"/*.so \
        | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); printf "*%s\n", so }' \
        | sort -u \
        | xargs -r dpkg-query --search \
        | cut -d: -f1 \
        | sort -u \
        | xargs -rt apt-mark manual; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*; \
    if ldd "$extDir"/*.so | grep 'not found'; then exit 1; fi; \
    php -r 'exit(in_array("mysql", PDO::getAvailableDrivers(), true) && extension_loaded("gd") && extension_loaded("ldap") ? 0 : 1);'

# PEAR mail packages, still used by the users portal invoice notification
RUN set -eux; \
    pear install Mail Mail_Mime Net_SMTP; \
    rm -rf /tmp/pear

# PHP configuration: production defaults plus hardening
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY daloradius-php.ini /usr/local/etc/php/conf.d/zz-daloradius.ini

# Install daloRADIUS
ENV DALORADIUS_PATH="/var/www/daloradius"

COPY source/ "${DALORADIUS_PATH}/"
RUN set -eux; \
    if [ ! -f "${DALORADIUS_PATH}/init.sh" ]; then \
        echo "daloRADIUS sources not found: clone this repository with --recursive" >&2; \
        exit 1; \
    fi; \
# The start script of daloRADIUS writes the configuration and updates the
# database. Let it hand over to the apache launcher of the PHP image, which
# passes the container's stop signal on to apache.
    sed -i 's/\r$//' "${DALORADIUS_PATH}/init.sh"; \
    grep -qx 'exec /usr/sbin/apachectl -DFOREGROUND -k start' "${DALORADIUS_PATH}/init.sh"; \
    sed -i 's|^exec /usr/sbin/apachectl -DFOREGROUND -k start$|exec apache2-foreground|' "${DALORADIUS_PATH}/init.sh"; \
# Both interfaces share one set of static files
    rm -rf "${DALORADIUS_PATH}/app/operators/static" "${DALORADIUS_PATH}/app/users/static"; \
    ln -s ../common/static "${DALORADIUS_PATH}/app/operators/static"; \
    ln -s ../common/static "${DALORADIUS_PATH}/app/users/static"; \
# Log and variable data directory, state directory of the start script
    mkdir -p "${DALORADIUS_PATH}/var/log" "${DALORADIUS_PATH}/var/backup" /data; \
    touch "${DALORADIUS_PATH}/var/log/daloradius.log"; \
# Set correct permissions
    chown -R www-data:www-data "${DALORADIUS_PATH}"

# Configure apache2 as daloRADIUS does: users portal on port 80, operators
# interface on port 8000
RUN set -eux; \
    cp "${DALORADIUS_PATH}/contrib/docker/users.conf" "${DALORADIUS_PATH}/contrib/docker/operators.conf" /etc/apache2/sites-available/; \
    echo 'Listen 8000' >> /etc/apache2/ports.conf; \
    a2dissite 000-default; \
    a2ensite users operators

WORKDIR ${DALORADIUS_PATH}

# Add entrypoint
COPY entrypoint.sh /daloradius-entrypoint.sh
ENTRYPOINT [ "/daloradius-entrypoint.sh" ]

EXPOSE 80 8000

CMD [ "bash", "/var/www/daloradius/init.sh" ]
