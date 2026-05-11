#!/bin/bash
set -eou pipefail

# Restrict permissions on any files/dirs created by this script.
umask 077

# --- Configuration ---
USER_HOME="$HOME"
TIMESTAMP=$(date +%F_%H-%M-%S)
CREDS_FILE="$USER_HOME/.mongo_creds"
RETENTION_DAYS=28

# Databases to back up: pass as arguments, or fall back to the default.
if [ $# -gt 0 ]; then
    DATABASES=("$@")
else
    DATABASES=("swgohbot")
fi

# --- Validate DB names (alphanumeric, hyphens, underscores only) ---
for DB_NAME in "${DATABASES[@]}"; do
    if [[ ! "$DB_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "Error: Invalid database name: '$DB_NAME'"
        exit 1
    fi
done

# --- Check creds file exists and is not world/group readable ---
if [[ ! -f "$CREDS_FILE" ]]; then
    echo "[$(date)] Error: Credentials file not found at $CREDS_FILE"
    exit 1
fi

CREDS_PERMS=$(stat -c '%a' "$CREDS_FILE")
if [[ "$CREDS_PERMS" != "600" ]]; then
    echo "Error: $CREDS_FILE has permissions $CREDS_PERMS — must be 600."
    echo "Fix with: chmod 600 $CREDS_FILE"
    exit 1
fi

# shellcheck source=/dev/null
source "$CREDS_FILE"

# --- Validate required creds are present ---
: "${MONGO_USER:?Error: MONGO_USER is not set in $CREDS_FILE}"
: "${MONGO_PASS:?Error: MONGO_PASS is not set in $CREDS_FILE}"
: "${MONGO_AUTH_DB:?Error: MONGO_AUTH_DB is not set in $CREDS_FILE}"

# Note: --password is visible in `ps aux`. On a single-user host this is
# acceptable; for a shared host consider a MongoDB config file or vault.

FAILED=()

for DB_NAME in "${DATABASES[@]}"; do
    BACKUP_DIR="$USER_HOME/backups/mongo/$DB_NAME"
    DEST_DIR="$BACKUP_DIR/$TIMESTAMP"
    ARCHIVE="$BACKUP_DIR/${DB_NAME}_${TIMESTAMP}.tar.gz"

    mkdir -p "$DEST_DIR"

    echo "Starting backup of $DB_NAME at $TIMESTAMP..."
    if mongodump \
        --host "localhost" \
        --username "$MONGO_USER" \
        --password "$MONGO_PASS" \
        --authenticationDatabase "$MONGO_AUTH_DB" \
        --db "$DB_NAME" \
        --out "$DEST_DIR"; then

        tar -czf "$ARCHIVE" -C "$BACKUP_DIR" "$TIMESTAMP"
        rm -rf "$DEST_DIR"

        # --- Future SCP Step ---
        # scp "$ARCHIVE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"

        find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +"$RETENTION_DAYS" -delete

        echo "Backup complete: $ARCHIVE"
    else
        echo "[$(date)] Mongodump failed for $DB_NAME!" >> "$USER_HOME/mongo_backup.log"
        FAILED+=("$DB_NAME")
    fi
done

if [ ${#FAILED[@]} -gt 0 ]; then
    echo "The following databases failed to back up: ${FAILED[*]}"
    exit 1
fi
