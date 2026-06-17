#!/bin/sh
set -eu

require_env() {
  var_name="$1"
  eval "var_value=\${$var_name:-}"

  if [ -z "$var_value" ]; then
    echo "Missing required environment variable: $var_name" >&2
    exit 1
  fi
}

require_env PUBLICHOST
require_env FTP_USER_NAME
require_env FTP_USER_PASS
require_env FTP_USER_HOME

FTP_USER_UID="${FTP_USER_UID:-1000}"
FTP_USER_GID="${FTP_USER_GID:-1000}"
FTP_PASSIVE_PORTS="${FTP_PASSIVE_PORTS:-30000:30009}"
FTP_MAX_CLIENTS="${FTP_MAX_CLIENTS:-10}"
FTP_MAX_CONNECTIONS="${FTP_MAX_CONNECTIONS:-10}"
PASSWD_FILE="/etc/pure-ftpd/passwd/pureftpd.passwd"
DB_FILE="/etc/pure-ftpd/pureftpd.pdb"
GROUP_NAME="ftpgroup"
USER_NAME="ftpuser"

mkdir -p /etc/pure-ftpd/passwd /run/pure-ftpd "$FTP_USER_HOME"

if ! grep -q "^$GROUP_NAME:" /etc/group; then
  addgroup -g "$FTP_USER_GID" -S "$GROUP_NAME"
fi

if ! grep -q "^$USER_NAME:" /etc/passwd; then
  adduser -u "$FTP_USER_UID" -S -D -h "$FTP_USER_HOME" -G "$GROUP_NAME" "$USER_NAME"
fi

chown "$FTP_USER_UID:$FTP_USER_GID" "$FTP_USER_HOME"

rm -f "$PASSWD_FILE" "$DB_FILE"
printf '%s\n%s\n' "$FTP_USER_PASS" "$FTP_USER_PASS" | pure-pw useradd "$FTP_USER_NAME" \
  -f "$PASSWD_FILE" \
  -m \
  -u "$FTP_USER_UID" \
  -g "$FTP_USER_GID" \
  -d "$FTP_USER_HOME"
pure-pw mkdb "$DB_FILE" -f "$PASSWD_FILE"

exec /usr/sbin/pure-ftpd \
  -l "puredb:$DB_FILE" \
  -E \
  -j \
  -R \
  -P "$PUBLICHOST" \
  -p "$FTP_PASSIVE_PORTS" \
  -c "$FTP_MAX_CLIENTS" \
  -C "$FTP_MAX_CONNECTIONS"
