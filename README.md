# daloRADIUS docker image

A daloRADIUS docker image configurable via environment variables.

It is built on the official ``php:8.4-apache`` image and installs daloRADIUS 2.4 from the ``source`` submodule.

## Building

This container must be built from a clone of this repository (or any valid fork). The ``--recursive`` flag must be used when cloning, as the ``source`` submodule contains the necessary files to install daloRADIUS on the container. If that is checked, the usual ``docker build --pull -t "daloradius" .`` should do it.

#### For example

```bash
IMAGE_NAME="daloradius"
# Cloning from a local git repo
REPO_ORIGIN="./docker-daloradius.git"
git clone --recursive "$REPO_ORIGIN" ./daloradius-docker
cd ./daloradius-docker
docker build --pull -t "$IMAGE_NAME" .
```

### PHP version and security updates

The ``PHP_VERSION`` build argument selects the tag of the official PHP image and defaults to the ``8.4`` branch. Always build with ``--pull``, so that the latest patch release of that branch is used, and rebuild the image whenever PHP publishes a security release.

```bash
# Build on another branch or on an exact release
docker build --pull --build-arg PHP_VERSION=8.4.27 -t "$IMAGE_NAME" .
```

The build fails on PHP releases that predate the fixes for CVE-2026-109618 and CVE-2026-109619 (older than 8.2.35, 8.3.36, 8.4.27 or 8.5.12). In addition, ``daloradius-php.ini`` disables session upload progress, which daloRADIUS does not use and which is the attack surface of CVE-2026-109619 and CVE-2026-115560.

## Running

### Environment configuration

| Variable name      | Description                                            | Default value |
|:-------------------|:-------------------------------------------------------|:--------------|
| ``RADIUS_DB_HOST`` | Hostname or address for the MySQL/MariaDB server       | _error_       |
| ``RADIUS_DB_PORT`` | Port of the MySQL/MariaDB server                       | ``3306``      |
| ``RADIUS_DB_NAME`` | Name of the radius database                            | _error_       |
| ``RADIUS_DB_USER`` | Username for a user with access to the radius database | _error_       |
| ``RADIUS_DB_PASS`` | Password for that user                                 | _error_       |

The variables that _error_ by default must be provided to the container on initialization.

Saving the settings in the operators interface rewrites the configuration file inside the container with the values that are in effect at that moment. From then on that container no longer reads the database settings from the environment; recreate it to go back to the environment variables.

### Ports

| Port     | Interface                                                 |
|:---------|:----------------------------------------------------------|
| ``80``   | Operators (management) interface                          |
| ``8000`` | Users (self-service) portal                               |

You need to publish the ones you need. The image serves plain HTTP only; put a TLS terminating reverse proxy in front of it and do not expose the operators interface to untrusted networks.

#### For example

```bash
IMAGE_NAME="daloradius"
docker run  -itd \
    --name daloradius \
    -e RADIUS_DB_HOST=myslq \
    -e RADIUS_DB_USER=freeradius \
    -e RADIUS_DB_PASS=radpass \
    -e RADIUS_DB_NAME=freeradius \
    -p 8080:80 \
    "$IMAGE_NAME"
```
This will create a container running detached with TTY, named ``daloradius`` from the image ``$IMAGE_NAME`` that accesses a MySQL server with hostname ``myslq`` (at the default port), as user ``freeradius`` with password ``radpass`` to the database named ``freeradius``, that then publishes the operators interface on the internal port ``80`` to the port ``8080``.

### Database initialization

Scripts for initializing the MySQL/MariaDB database can be found on the ``contrib/db/`` directory of the daloRADIUS project, or in the ``/var/www/daloradius/contrib/db/`` directory of this image:

| Script                                  | Content                                   |
|:----------------------------------------|:------------------------------------------|
| ``fr3-mariadb-freeradius.sql``          | FreeRADIUS 3 tables                       |
| ``mariadb-daloradius.sql``              | daloRADIUS tables and the default operator |
| ``mariadb-daloradius-dictionaries.sql`` | Attribute dictionary                      |

The daloRADIUS script creates the operator ``administrator`` with the password ``radius``. Change that password right after the first login.

#### For example

Say you have a mysql container that servers as a datastore for a freeRADIUS installation, in that case you can initialize the database with these commands.

```bash
# Usually the default script is want you want
DB_SCRIPT="mariadb-daloradius.sql"
DR_CONTAINER_NAME="daloradius"
MYSQL_CONTAINER_NAME="mysql"
DB_USER="freeradius"
DB_PASS="radpass"
DB_NAME="freeradius"

docker exec "$DR_CONTAINER_NAME" \
    cat "/var/www/daloradius/contrib/db/$DB_SCRIPT" |
docker exec -i "$MYSQL_CONTAINER_NAME" \
    mysql \
        "-u${DB_USER}" \
        "-p${DB_PASS}" \
        "$DB_NAME"
```

## Upgrading from earlier versions of this image

Earlier versions were based on Ubuntu 16.04 with PHP 7.0 and daloRADIUS 0.9-9. Neither receives security fixes any more, so this is a replacement rather than an in-place update:

* daloRADIUS 2.4 uses a newer database schema. Back up the database first, then follow the daloRADIUS upgrade notes and apply the relevant scripts from ``contrib/db/migrations/`` before using an existing database with this image.
* daloRADIUS is installed in ``/var/www/daloradius`` instead of ``/var/www/html``.
* The users portal has its own port (``8000``) instead of a sub directory of the operators interface.
* Port ``443`` is no longer exposed, it never served TLS.
