#!/bin/bash

# The database connection can be configured with the MYSQL_* variables of the
# daloRADIUS project or with the RADIUS_DB_* variables of earlier versions of
# this image. MYSQL_* wins when both are set.
use_alias() {
    local name="$1" alias="$2"
    if [[ -z "${!name:-}" && -n "${!alias:-}" ]]; then
        export "$name=${!alias}"
    fi
}

use_alias "MYSQL_HOST"     "RADIUS_DB_HOST"
use_alias "MYSQL_PORT"     "RADIUS_DB_PORT"
use_alias "MYSQL_DATABASE" "RADIUS_DB_NAME"
use_alias "MYSQL_USER"     "RADIUS_DB_USER"
use_alias "MYSQL_PASSWORD" "RADIUS_DB_PASS"

missing=0
for pair in "MYSQL_HOST:RADIUS_DB_HOST" "MYSQL_USER:RADIUS_DB_USER" "MYSQL_PASSWORD:RADIUS_DB_PASS" "MYSQL_DATABASE:RADIUS_DB_NAME"; do
    name="${pair%%:*}"
    if [[ -z "${!name:-}" ]]; then
        echo "error: Variable $name (or ${pair##*:}) must be set to a non-empty value." 1>&2
        missing=1
    fi
done
if [[ "$missing" -ne 0 ]]; then
    exit 1
fi

if [[ -z "${MYSQL_PORT:-}" ]]; then
    export "MYSQL_PORT=3306"
fi

# Replace the shell so that apache receives the container's stop signal
exec "$@"
