#!/bin/bash
#
# Smoke test for the daloRADIUS image.
#
# Starts the image next to a throwaway MariaDB container and checks that
#   1. a new, empty database is set up and both web interfaces work,
#   2. the RADIUS_DB_* variables of earlier versions of this image still work,
#   3. a database created by the daloRADIUS docker image of 2024 is updated
#      on start and its operator can still log in.
#
# Usage: test/smoke-test.sh [IMAGE]
#        IMAGE defaults to "daloradius"

set -euo pipefail

image="${1:-daloradius}"
db_image="${DB_IMAGE:-mariadb:lts}"
fixtures="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/fixtures"

prefix="daloradius-smoke-$$"
network="$prefix"
volume="$prefix-data"
db="$prefix-db"
containers=("$db")

db_user="radius"
db_pass="Sm0ke-test_Pass.1"
db_root_pass="Sm0ke-test_Root.1"

workdir="$(mktemp -d)"
operators_url=""
users_url=""
last_web=""

step() {
    printf '\n==> %s\n' "$*"
}

fail() {
    echo "FAILED: $*" >&2
    exit 1
}

cleanup() {
    local status=$?
    if [[ $status -ne 0 && -n "$last_web" ]]; then
        echo
        echo "---- last log lines of $last_web ----"
        docker logs --tail 40 "$last_web" 2>&1 || true
    fi
    docker rm -f "${containers[@]}" > /dev/null 2>&1 || true
    docker volume rm "$volume" > /dev/null 2>&1 || true
    docker network rm "$network" > /dev/null 2>&1 || true
    rm -rf "$workdir"
    exit "$status"
}
trap cleanup EXIT

# Prints the HTTP status of a GET request, 000 if the server is unreachable
http_status() {
    curl -s -o /dev/null -w '%{http_code}' --max-time 10 "$@" || true
}

expect_status() {
    local expected="$1" url="$2" status
    status="$(http_status "$url")"
    if [[ "$status" != "$expected" ]]; then
        fail "GET $url returned $status, expected $expected"
    fi
    echo "ok: GET $url -> $status"
}

# Tries to log in to the operators interface, prints the redirect target
operator_login() {
    local base_url="$1" username="$2" password="$3" jar="$4" token
    token="$(curl -s --max-time 10 -c "$jar" "$base_url/login.php" |
        sed -n 's/.*name="csrf_token"[^>]*value="\([^"]*\)".*/\1/p' | head -n 1)"
    [[ -n "$token" ]] || fail "no CSRF token found on $base_url/login.php"
    curl -s -o /dev/null --max-time 10 -b "$jar" -c "$jar" -w '%{redirect_url}' \
        --data-urlencode "csrf_token=$token" \
        --data-urlencode "operator_user=$username" \
        --data-urlencode "operator_pass=$password" \
        --data-urlencode "location=default" \
        "$base_url/dologin.php"
}

expect_operator_login() {
    local jar="$workdir/$1.jar" target status
    target="$(operator_login "$operators_url" administrator radius "$jar")"
    [[ "$target" == */index.php ]] ||
        fail "login as administrator was redirected to '$target' instead of index.php"
    status="$(http_status -b "$jar" "$operators_url/home-main.php")"
    [[ "$status" == "200" ]] || fail "home-main.php returned $status after login"
    echo "ok: operator can log in and gets the home page"
}

# Runs SQL from stdin in the given database as the application user
run_sql() {
    docker exec -i "$db" mariadb "-u$db_user" "-p$db_pass" "$1"
}

# Prints a file shipped in the image
image_file() {
    docker run --rm --entrypoint cat "$image" "$1"
}

# start_web NAME VARIABLE_STYLE DATABASE [docker run options...]
# Starts the image and waits until the web interfaces answer. Apache is only
# started after the database has been set up or updated.
start_web() {
    local name="$1" style="$2" database="$3" attempt
    shift 3
    local env=()
    if [[ "$style" == "MYSQL" ]]; then
        env=(-e "MYSQL_HOST=$db" -e "MYSQL_DATABASE=$database"
            -e "MYSQL_USER=$db_user" -e "MYSQL_PASSWORD=$db_pass")
    else
        env=(-e "RADIUS_DB_HOST=$db" -e "RADIUS_DB_NAME=$database"
            -e "RADIUS_DB_USER=$db_user" -e "RADIUS_DB_PASS=$db_pass")
    fi
    containers+=("$name")
    last_web="$name"
    docker run -d --name "$name" --network "$network" "${env[@]}" \
        -e MYSQL_WAIT_INTERVAL=1 \
        -p 127.0.0.1::80 -p 127.0.0.1::8000 \
        "$@" "$image" > /dev/null
    users_url="http://$(docker port "$name" 80/tcp | head -n 1)"
    operators_url="http://$(docker port "$name" 8000/tcp | head -n 1)"
    for attempt in $(seq 1 60); do
        if [[ "$(http_status "$operators_url/login.php")" == "200" ]]; then
            echo "ok: operators interface at $operators_url, users portal at $users_url"
            return
        fi
        if [[ "$(docker inspect -f '{{.State.Running}}' "$name")" != "true" ]]; then
            fail "container $name exited during start"
        fi
        sleep 2
    done
    fail "operators interface of $name did not come up at $operators_url"
}


step "PHP runtime of $image"
docker run --rm --entrypoint php "$image" -r '
    echo "PHP ", PHP_VERSION, PHP_EOL;
    $problems = [];
    foreach (["curl", "gd", "ldap", "mbstring", "pdo_mysql"] as $extension) {
        if (!extension_loaded($extension)) {
            $problems[] = "extension $extension is not loaded";
        }
    }
    if (ini_get("session.upload_progress.enabled")) {
        $problems[] = "session.upload_progress.enabled is on";
    }
    if (ini_get("expose_php")) {
        $problems[] = "expose_php is on";
    }
    foreach (["Mail.php", "Mail/mime.php", "Net/SMTP.php"] as $file) {
        if (stream_resolve_include_path($file) === false) {
            $problems[] = "PEAR file $file is missing";
        }
    }
    foreach ($problems as $problem) {
        fwrite(STDERR, $problem . PHP_EOL);
    }
    exit($problems ? 1 : 0);
' || fail "PHP runtime check"
docker run --rm --entrypoint sh "$image" -c \
    'command -v radclient > /dev/null && command -v mysql > /dev/null && command -v mysqladmin > /dev/null' ||
    fail "radclient or the database client is missing"
echo "ok: extensions, settings, PEAR mail packages, radclient and database client"

step "Required variables are enforced"
if docker run --rm "$image" true > /dev/null 2>&1; then
    fail "container started without database variables"
fi
echo "ok: container refuses to start without database variables"

step "Starting database ($db_image)"
docker network create "$network" > /dev/null
docker run -d --name "$db" --network "$network" \
    -e "MARIADB_ROOT_PASSWORD=$db_root_pass" \
    -e "MARIADB_DATABASE=radius" \
    -e "MARIADB_USER=$db_user" \
    -e "MARIADB_PASSWORD=$db_pass" \
    "$db_image" > /dev/null
for attempt in $(seq 1 60); do
    if docker exec "$db" mariadb -h127.0.0.1 "-u$db_user" "-p$db_pass" radius \
        -e 'SELECT 1' > /dev/null 2>&1; then
        break
    fi
    [[ "$attempt" -lt 60 ]] || fail "database did not become ready"
    sleep 2
done
echo "ok: database accepts connections"
# FreeRADIUS normally creates its tables itself
image_file /var/www/daloradius/contrib/db/fr3-mariadb-freeradius.sql | run_sql radius
echo "ok: loaded the FreeRADIUS tables"


step "1. New database, MYSQL_* variables"
start_web "$prefix-new" MYSQL radius

echo "Operators interface (port 8000)"
expect_status 200 "$operators_url/login.php"
expect_status 200 "$operators_url/static/css/bootstrap.min.css"
expect_status 403 "$operators_url/notifications/"
expect_status 302 "$operators_url/home-main.php"
if ! curl -s --max-time 10 "$operators_url/login.php" | grep -q 'name="operator_user"'; then
    fail "operators login form not found"
fi
echo "ok: login form is served"

echo "Users portal (port 80)"
# The users portal answers 503 when it cannot read from the database
expect_status 200 "$users_url/login.php"
expect_status 200 "$users_url/static/css/bootstrap.min.css"
expect_status 403 "$users_url/notifications/"
if curl -s --max-time 10 "$users_url/login.php" | grep -q 'name="operator_user"'; then
    fail "port 80 serves the operators interface instead of the users portal"
fi

echo "Operator login"
expect_operator_login new
target="$(operator_login "$operators_url" administrator wrong-password "$workdir/bad.jar")"
[[ "$target" == */login.php ]] ||
    fail "login with a wrong password was redirected to '$target' instead of login.php"
echo "ok: wrong password is rejected"

echo "Container stop"
docker stop -t 20 "$prefix-new" > /dev/null
exit_code="$(docker inspect -f '{{.State.ExitCode}}' "$prefix-new")"
[[ "$exit_code" == "0" ]] || fail "apache exited with code $exit_code (killed instead of stopped?)"
echo "ok: apache shut down on the stop signal"


step "2. Same database, RADIUS_DB_* variables"
start_web "$prefix-alias" RADIUS_DB radius
expect_status 200 "$users_url/login.php"
expect_operator_login alias
docker rm -f "$prefix-alias" > /dev/null


step "3. Database and /data volume created by the daloRADIUS image of 2024"
docker exec "$db" mariadb -uroot "-p$db_root_pass" -e \
    "CREATE DATABASE legacy; GRANT ALL PRIVILEGES ON legacy.* TO '$db_user'@'%';"
image_file /var/www/daloradius/contrib/db/fr3-mariadb-freeradius.sql | run_sql legacy
run_sql legacy < "$fixtures/legacy-2024-daloradius.sql"
echo "ok: loaded the 2024 database schema"
docker volume create "$volume" > /dev/null
docker run --rm --entrypoint sh -v "$volume:/data" "$image" -c \
    'date > /data/.init_done && date > /data/.db_init_done'
start_web "$prefix-legacy" MYSQL legacy -v "$volume:/data"
expect_status 200 "$users_url/login.php"
expect_operator_login legacy

echo
echo "All checks passed for $image"
