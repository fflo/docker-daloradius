#!/bin/bash
#
# Smoke test for the daloRADIUS image.
#
# Starts the image next to a throwaway MariaDB container, loads the database
# scripts shipped in the image and checks that both web interfaces answer and
# that the default operator can log in.
#
# Usage: test/smoke-test.sh [IMAGE]
#        IMAGE defaults to "daloradius"

set -euo pipefail

image="${1:-daloradius}"
db_image="${DB_IMAGE:-mariadb:lts}"

prefix="daloradius-smoke-$$"
network="$prefix"
db="$prefix-db"
web="$prefix-web"

db_name="radius"
db_user="radius"
# Quote and backslash on purpose: the password must survive config.patch
db_pass="Sm0ke'test\\pass"

workdir="$(mktemp -d)"

step() {
    printf '\n==> %s\n' "$*"
}

fail() {
    echo "FAILED: $*" >&2
    exit 1
}

cleanup() {
    local status=$?
    if [[ $status -ne 0 ]]; then
        echo
        echo "---- last log lines of the daloRADIUS container ----"
        docker logs --tail 40 "$web" 2>&1 || true
    fi
    docker rm -f "$web" "$db" > /dev/null 2>&1 || true
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

load_sql() {
    local script="$1"
    docker exec "$web" cat "/var/www/daloradius/contrib/db/$script" |
        docker exec -i "$db" mariadb "-u$db_user" "-p$db_pass" "$db_name"
    echo "ok: loaded $script"
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
docker run --rm --entrypoint sh "$image" -c 'command -v radclient > /dev/null' ||
    fail "radclient is missing"
echo "ok: extensions, settings, PEAR mail packages and radclient"

step "Required variables are enforced"
if docker run --rm "$image" true > /dev/null 2>&1; then
    fail "container started without the RADIUS_DB_* variables"
fi
echo "ok: container refuses to start without RADIUS_DB_* variables"

step "Starting database ($db_image)"
docker network create "$network" > /dev/null
docker run -d --name "$db" --network "$network" \
    -e MARIADB_RANDOM_ROOT_PASSWORD=1 \
    -e "MARIADB_DATABASE=$db_name" \
    -e "MARIADB_USER=$db_user" \
    -e "MARIADB_PASSWORD=$db_pass" \
    "$db_image" > /dev/null
for attempt in $(seq 1 60); do
    if docker exec "$db" mariadb -h127.0.0.1 "-u$db_user" "-p$db_pass" "$db_name" \
        -e 'SELECT 1' > /dev/null 2>&1; then
        break
    fi
    [[ "$attempt" -lt 60 ]] || fail "database did not become ready"
    sleep 2
done
echo "ok: database accepts connections"

step "Starting daloRADIUS"
docker run -d --name "$web" --network "$network" \
    -e "RADIUS_DB_HOST=$db" \
    -e "RADIUS_DB_NAME=$db_name" \
    -e "RADIUS_DB_USER=$db_user" \
    -e "RADIUS_DB_PASS=$db_pass" \
    -p 127.0.0.1::80 \
    -p 127.0.0.1::8000 \
    "$image" > /dev/null
operators_url="http://$(docker port "$web" 80/tcp | head -n 1)"
users_url="http://$(docker port "$web" 8000/tcp | head -n 1)"
for attempt in $(seq 1 30); do
    if [[ "$(http_status "$operators_url/login.php")" == "200" ]]; then
        break
    fi
    [[ "$attempt" -lt 30 ]] || fail "operators interface did not come up at $operators_url"
    sleep 2
done
echo "ok: operators interface at $operators_url, users portal at $users_url"

step "Loading database scripts shipped in the image"
load_sql fr3-mariadb-freeradius.sql
load_sql mariadb-daloradius.sql
load_sql mariadb-daloradius-dictionaries.sql

step "Operators interface (port 80)"
expect_status 200 "$operators_url/login.php"
expect_status 200 "$operators_url/static/css/bootstrap.min.css"
expect_status 403 "$operators_url/notifications/"
if ! curl -s --max-time 10 "$operators_url/login.php" | grep -q 'name="operator_user"'; then
    fail "operators login form not found"
fi
echo "ok: login form is served"

step "Users portal (port 8000)"
# The users portal answers 503 when it cannot read from the database
expect_status 200 "$users_url/login.php"
expect_status 200 "$users_url/static/css/bootstrap.min.css"
expect_status 403 "$users_url/notifications/"

step "Operator login"
target="$(operator_login "$operators_url" administrator radius "$workdir/good.jar")"
[[ "$target" == */index.php ]] ||
    fail "login as administrator was redirected to '$target' instead of index.php"
echo "ok: default operator can log in"
expect_status 302 "$operators_url/home-main.php"
status="$(http_status -b "$workdir/good.jar" "$operators_url/home-main.php")"
[[ "$status" == "200" ]] || fail "home-main.php returned $status after login"
echo "ok: home page is served after login and only then"
target="$(operator_login "$operators_url" administrator wrong-password "$workdir/bad.jar")"
[[ "$target" == */login.php ]] ||
    fail "login with a wrong password was redirected to '$target' instead of login.php"
echo "ok: wrong password is rejected"

step "Container stops cleanly"
docker stop -t 20 "$web" > /dev/null
exit_code="$(docker inspect -f '{{.State.ExitCode}}' "$web")"
[[ "$exit_code" == "0" ]] || fail "apache exited with code $exit_code (killed instead of stopped?)"
echo "ok: apache shut down on the stop signal"

echo
echo "All checks passed for $image"
