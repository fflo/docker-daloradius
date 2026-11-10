# daloRADIUS docker image

A [daloRADIUS](https://github.com/lirantal/daloradius) docker image configurable via environment variables.

The image is built on the official ``php:8.4-apache`` image and installs daloRADIUS from the ``source`` submodule (currently version 2.4). It contains the web interfaces only: FreeRADIUS and the MariaDB database run elsewhere. Configuration, ports and database handling are those of the Docker image of the daloRADIUS project, because the container is started by the same script.

Ready-made images are published on Docker Hub as [``fflo/daloradius``](https://hub.docker.com/r/fflo/daloradius), see [Automated builds](#automated-builds).

## Running

```bash
docker pull fflo/daloradius
```

### Environment configuration

| Variable name      | Alias              | Description                                            | Default value |
|:-------------------|:-------------------|:-------------------------------------------------------|:--------------|
| ``MYSQL_HOST``     | ``RADIUS_DB_HOST`` | Hostname or address of the MariaDB server              | _error_       |
| ``MYSQL_PORT``     | ``RADIUS_DB_PORT`` | Port of the MariaDB server                             | ``3306``      |
| ``MYSQL_DATABASE`` | ``RADIUS_DB_NAME`` | Name of the radius database                            | _error_       |
| ``MYSQL_USER``     | ``RADIUS_DB_USER`` | Username for a user with access to the radius database | _error_       |
| ``MYSQL_PASSWORD`` | ``RADIUS_DB_PASS`` | Password for that user                                 | _error_       |

The variables that _error_ by default must be provided to the container on initialization, otherwise it exits with an error message. The aliases are the variable names of earlier versions of this repository; ``MYSQL_*`` wins when both are set.

Optional variables of the daloRADIUS start script work as well, for example ``PASSWORD_MIN_LENGTH``, ``PASSWORD_MAX_LENGTH``, ``DEFAULT_FREERADIUS_SERVER``, ``DEFAULT_FREERADIUS_PORT``, ``DEFAULT_CLIENT_SECRET``, the ``MAIL_*`` variables and the ``DALORADIUS_*`` variables for operator logins via LDAP. They are described in [README.docker.md](https://github.com/lirantal/daloradius/blob/master/README.docker.md) of the daloRADIUS project.

The variables are written to the daloRADIUS configuration file when a container starts for the first time. To change them, recreate the container (``docker compose up -d`` does that when the environment changed).

### Ports

| Port     | Interface                        |
|:---------|:---------------------------------|
| ``80``   | Users (self-service) portal      |
| ``8000`` | Operators (management) interface |

You need to publish the ones you need. The image serves plain HTTP only; put a TLS terminating reverse proxy in front of it and do not expose the operators interface to untrusted networks.

### Volume

The start script keeps two marker files in ``/data`` that record that the configuration and the database were initialized. Mounting a volume there is optional.

#### For example

```bash
IMAGE_NAME="fflo/daloradius"
docker run  -itd \
    --name daloradius \
    -e MYSQL_HOST=mariadb \
    -e MYSQL_USER=freeradius \
    -e MYSQL_PASSWORD=radpass \
    -e MYSQL_DATABASE=freeradius \
    -p 8080:8000 \
    "$IMAGE_NAME"
```
This will create a container running detached with TTY, named ``daloradius`` from the image ``$IMAGE_NAME`` that accesses a MariaDB server with hostname ``mariadb`` (at the default port), as user ``freeradius`` with password ``radpass`` to the database named ``freeradius``, and that publishes the operators interface on the internal port ``8000`` to the port ``8080``.

The same with docker compose:

```yaml
services:
  daloradius:
    image: fflo/daloradius
    environment:
      MYSQL_HOST: mariadb
      MYSQL_USER: freeradius
      MYSQL_PASSWORD: radpass
      MYSQL_DATABASE: freeradius
    volumes:
      - ./data:/data
    ports:
      - "8080:8000"
    restart: unless-stopped
```

### Database

The container waits for the database server and then, before the web interfaces become available,

* creates the daloRADIUS tables and the attribute dictionary if the database does not contain them yet,
* updates the ``operators`` table of databases created by earlier daloRADIUS versions (password hashing, LDAP and two-factor login columns).

Back up the database before you start a new version of the image on it. Further scripts for changes introduced by newer daloRADIUS versions are in ``/var/www/daloradius/contrib/db/migrations/`` and are applied by hand; README.docker.md of the daloRADIUS project says which one is needed for which feature.

The FreeRADIUS tables are not created, FreeRADIUS normally does that itself. If they are missing, load ``/var/www/daloradius/contrib/db/fr3-mariadb-freeradius.sql`` into the database before the first start:

```bash
DB_CONTAINER_NAME="mariadb"
DB_USER="freeradius"
DB_PASS="radpass"
DB_NAME="freeradius"

docker run --rm --entrypoint cat fflo/daloradius \
    /var/www/daloradius/contrib/db/fr3-mariadb-freeradius.sql |
docker exec -i "$DB_CONTAINER_NAME" \
    mariadb \
        "-u${DB_USER}" \
        "-p${DB_PASS}" \
        "$DB_NAME"
```

The scripts are written for MariaDB, the only database daloRADIUS is tested with.

A new database gets the operator ``administrator`` with the password ``radius``. Change that password right after the first login.

## Building

This container must be built from a clone of this repository (or any valid fork). The ``--recursive`` flag must be used when cloning, as the ``source`` submodule contains the necessary files to install daloRADIUS on the container. If that is checked, the usual ``docker build --pull -t "daloradius" .`` should do it.

#### For example

```bash
IMAGE_NAME="daloradius"
git clone --recursive https://github.com/fflo/docker-daloradius.git ./daloradius-docker
cd ./daloradius-docker
docker build --pull -t "$IMAGE_NAME" .
```

### PHP version

The ``PHP_VERSION`` build argument selects the tag of the official PHP image and defaults to the ``8.4`` branch. Always build with ``--pull``, so that the latest patch release of that branch is used.

```bash
# Build on another branch or on an exact release
docker build --pull --build-arg PHP_VERSION=8.4.27 -t "$IMAGE_NAME" .
```

The build fails on PHP releases that predate the fixes for CVE-2026-109618 and CVE-2026-109619 (older than 8.2.35, 8.3.36, 8.4.27 or 8.5.12). In addition, ``daloradius-php.ini`` disables session upload progress, which daloRADIUS does not use and which is the attack surface of CVE-2026-109619 and CVE-2026-115560.

### Testing

``test/smoke-test.sh`` starts an image next to a temporary MariaDB container and checks a new database, the ``RADIUS_DB_*`` aliases and the update of a database created by the image of 2024: both interfaces must answer and the default operator must be able to log in. It needs docker and curl and cleans up after itself.

```bash
test/smoke-test.sh "$IMAGE_NAME"
```

## Automated builds

The GitHub Actions workflow in ``.github/workflows/docker.yml`` builds the image and runs the smoke test

* for every pull request,
* for every push to the ``master`` branch,
* every Monday, to pick up new patch releases of the PHP base image,
* on demand, with the _Run workflow_ button on the _Actions_ tab of the repository. Use it when PHP publishes a security release and you do not want to wait for Monday.

Builds of the ``master`` branch that pass the smoke test are published to Docker Hub for ``linux/amd64`` and ``linux/arm64`` with these tags:

| Tag                    | Meaning                                            |
|:-----------------------|:---------------------------------------------------|
| ``latest``             | Most recent build                                  |
| ``2.4``                | Most recent build of that daloRADIUS version       |
| ``2.4-php8.4.27``      | That daloRADIUS version on that exact PHP release  |

### Setup

Publishing needs the repository secret ``DOCKERHUB_TOKEN``. The secret ``DOCKERHUB_USERNAME`` is optional and overrides the account name set in the workflow file:

1. On Docker Hub, create a personal access token with the _Read & Write_ scope (_Account settings_, _Personal access tokens_).
2. On GitHub, add it as the repository secret ``DOCKERHUB_TOKEN`` (_Settings_, _Secrets and variables_, _Actions_). A Docker Hub password works as well, a token is safer.

Without ``DOCKERHUB_TOKEN`` the workflow still builds and tests, it only skips publishing. The Docker Hub repository, the account name and the PHP branch are set in the ``env`` section at the top of the workflow file.

The weekly run and Dependabot only work on the default branch of the repository, so ``master`` must be the default branch. GitHub disables scheduled workflows in repositories without any activity for 60 days. It sends an e-mail before doing so; re-enable the workflow on the _Actions_ tab in that case.

### Updates

Dependabot (``.github/dependabot.yml``) opens pull requests for new daloRADIUS commits and for new versions of the actions used by the workflow. Each pull request is built and smoke tested; merging it into ``master`` publishes the new image.

To move to another PHP branch, change ``PHP_VERSION`` in the workflow file and the default of the build argument in the ``Dockerfile``.

## Upgrading

### From the Docker Hub image published before November 2026

That image used the ``MYSQL_*`` variables, the ports and the ``/data`` volume of the Docker image of the daloRADIUS project. The current image accepts the same, so the compose file can stay as it is. Back up the database first: on the first start the ``operators`` table is updated as described under [Database](#database). The smoke test covers this upgrade with a database schema of October 2024.

### From the 2018 state of this repository

The ``oldstable`` branch (Ubuntu 16.04, PHP 7.0, daloRADIUS 0.9-9) receives no security fixes any more.

* The ``RADIUS_DB_*`` variables still work.
* The operators interface moved from port ``80`` to port ``8000``; port ``80`` now serves the users portal, which used to be a sub directory. Port ``443`` is no longer exposed, it never served TLS.
* daloRADIUS is installed in ``/var/www/daloradius`` instead of ``/var/www/html``.
* The database schema of daloRADIUS 0.9-9 is not updated automatically. Back up the database and follow the upgrade notes of the daloRADIUS project before using it with this image.
