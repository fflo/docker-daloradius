# daloRADIUS docker image

A [daloRADIUS](https://github.com/lirantal/daloradius) docker image configurable via environment variables.

The image is built on the official ``php:8.4-apache`` image and installs daloRADIUS from the ``source`` submodule (currently version 2.4). It contains the web interfaces only: FreeRADIUS and the MariaDB database run elsewhere.

Ready-made images are published on Docker Hub as [``fflo/daloradius``](https://hub.docker.com/r/fflo/daloradius), see [Automated builds](#automated-builds).

## Running

```bash
docker pull fflo/daloradius
```

### Environment configuration

| Variable name      | Description                                            | Default value |
|:-------------------|:-------------------------------------------------------|:--------------|
| ``RADIUS_DB_HOST`` | Hostname or address of the MariaDB server              | _error_       |
| ``RADIUS_DB_PORT`` | Port of the MariaDB server                             | ``3306``      |
| ``RADIUS_DB_NAME`` | Name of the radius database                            | _error_       |
| ``RADIUS_DB_USER`` | Username for a user with access to the radius database | _error_       |
| ``RADIUS_DB_PASS`` | Password for that user                                 | _error_       |

The variables that _error_ by default must be provided to the container on initialization, otherwise it exits with an error message.

Saving the settings in the operators interface rewrites the configuration file inside the container with the values that are in effect at that moment. From then on that container no longer reads the database settings from the environment; recreate it to go back to the environment variables.

### Ports

| Port     | Interface                        |
|:---------|:---------------------------------|
| ``80``   | Operators (management) interface |
| ``8000`` | Users (self-service) portal      |

You need to publish the ones you need. The image serves plain HTTP only; put a TLS terminating reverse proxy in front of it and do not expose the operators interface to untrusted networks.

#### For example

```bash
IMAGE_NAME="fflo/daloradius"
docker run  -itd \
    --name daloradius \
    -e RADIUS_DB_HOST=mariadb \
    -e RADIUS_DB_USER=freeradius \
    -e RADIUS_DB_PASS=radpass \
    -e RADIUS_DB_NAME=freeradius \
    -p 8080:80 \
    "$IMAGE_NAME"
```
This will create a container running detached with TTY, named ``daloradius`` from the image ``$IMAGE_NAME`` that accesses a MariaDB server with hostname ``mariadb`` (at the default port), as user ``freeradius`` with password ``radpass`` to the database named ``freeradius``, and that publishes the operators interface on the internal port ``80`` to the port ``8080``.

### Database initialization

Scripts for initializing the database can be found in the ``contrib/db/`` directory of the daloRADIUS project, or in the ``/var/www/daloradius/contrib/db/`` directory of this image. Load them in this order:

| Script                                  | Content                                    |
|:----------------------------------------|:-------------------------------------------|
| ``fr3-mariadb-freeradius.sql``          | FreeRADIUS 3 tables                        |
| ``mariadb-daloradius.sql``              | daloRADIUS tables and the default operator |
| ``mariadb-daloradius-dictionaries.sql`` | Attribute dictionary                       |

The scripts are written for MariaDB, the only database daloRADIUS is tested with. MySQL rejects them in its default strict SQL mode.

The daloRADIUS script creates the operator ``administrator`` with the password ``radius``. Change that password right after the first login.

#### For example

Say you have a MariaDB container that serves as a datastore for a FreeRADIUS installation, in that case you can initialize the database with these commands.

```bash
DR_CONTAINER_NAME="daloradius"
DB_CONTAINER_NAME="mariadb"
DB_USER="freeradius"
DB_PASS="radpass"
DB_NAME="freeradius"

# Skip fr3-mariadb-freeradius.sql if FreeRADIUS already created its tables
for DB_SCRIPT in fr3-mariadb-freeradius.sql mariadb-daloradius.sql mariadb-daloradius-dictionaries.sql; do
    docker exec "$DR_CONTAINER_NAME" \
        cat "/var/www/daloradius/contrib/db/$DB_SCRIPT" |
    docker exec -i "$DB_CONTAINER_NAME" \
        mariadb \
            "-u${DB_USER}" \
            "-p${DB_PASS}" \
            "$DB_NAME"
done
```

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

``test/smoke-test.sh`` starts an image next to a temporary MariaDB container, loads the database scripts and checks that both interfaces answer and that the default operator can log in. It needs docker and curl and cleans up after itself.

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

## Upgrading from earlier versions of this image

Earlier versions were based on Ubuntu 16.04 with PHP 7.0 and daloRADIUS 0.9-9. Neither receives security fixes any more, so this is a replacement rather than an in-place update:

* daloRADIUS 2.4 uses a newer database schema. Back up the database first, then follow the daloRADIUS upgrade notes and apply the relevant scripts from ``contrib/db/migrations/`` before using an existing database with this image.
* daloRADIUS is installed in ``/var/www/daloradius`` instead of ``/var/www/html``.
* The users portal has its own port (``8000``) instead of a sub directory of the operators interface.
* Port ``443`` is no longer exposed, it never served TLS.
