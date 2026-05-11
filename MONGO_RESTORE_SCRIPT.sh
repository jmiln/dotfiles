#!/bin/bash
set -eou pipefail

# Restrict permissions on any files/dirs created by this script.
umask 077

# --- Configuration ---
USER_HOME="$HOME"
BACKUP_BASE="$USER_HOME/backups/mongo"
CREDS_FILE="$USER_HOME/.mongo_creds"
TIMESTAMP=$(date +%F_%H-%M-%S)

# --- Parse Arguments ---
# Usage: ./MONGO_RESTORE_SCRIPT.sh [--date YYYY-MM-DD] [--dry-run] [db1 db2 ...]
DATE=""
MONGORESTORE_EXTRA=()
DBS_FROM_ARGS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --date|-d)
            DATE="$2"
            shift 2
            ;;
        --dry-run)
            MONGORESTORE_EXTRA+=("--dryRun")
            echo "--- DRY RUN MODE: No changes will be made ---"
            shift
            ;;
        *)
            DBS_FROM_ARGS+=("$1")
            shift
            ;;
    esac
done

# --- Validate date format if provided ---
if [[ -n "$DATE" && ! "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Error: --date must be in YYYY-MM-DD format, got: '$DATE'"
    exit 1
fi

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

# --- Helpers ---
pick_one() {
    local prompt="$1"; shift
    if command -v fzf &>/dev/null; then
        printf '%s\n' "$@" | fzf --prompt="$prompt > "
    else
        echo "$prompt:" >&2
        select opt in "$@"; do echo "$opt"; break; done
    fi
}

pick_many() {
    local prompt="$1"; shift
    if command -v fzf &>/dev/null; then
        printf '%s\n' "$@" | fzf --multi --prompt="$prompt > " \
            --header="TAB to select multiple, ENTER to confirm"
    else
        echo "$prompt (space-separated numbers):" >&2
        local i=1
        for opt in "$@"; do echo "  $i) $opt"; ((i++)); done
        read -r -p "Selection: " choices
        for n in $choices; do
            local arr=("$@")
            echo "${arr[$((n-1))]}"
        done
    fi
}

# --- Validate DB name format ---
validate_db_name() {
    local name="$1"
    if [[ ! "$name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo "Error: Invalid database name: '$name'"
        exit 1
    fi
}

# --- Select Databases ---
mapfile -t ALL_DBS < <(find "$BACKUP_BASE" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null \
    | xargs -0 -I{} basename {} | sort || true)

if [[ ${#ALL_DBS[@]} -eq 0 ]]; then
    echo "No backups found in $BACKUP_BASE"
    exit 1
fi

if [[ ${#DBS_FROM_ARGS[@]} -gt 0 ]]; then
    for db in "${DBS_FROM_ARGS[@]}"; do validate_db_name "$db"; done
    DATABASES=("${DBS_FROM_ARGS[@]}")
elif [[ -n "$DATE" ]]; then
    # --date with no explicit DBs: restore everything available for that date
    DATABASES=("${ALL_DBS[@]}")
else
    mapfile -t DATABASES < <(pick_many "Select databases to restore" "${ALL_DBS[@]}")
    for db in "${DATABASES[@]}"; do validate_db_name "$db"; done
fi

if [[ ${#DATABASES[@]} -eq 0 ]]; then
    echo "No databases selected."
    exit 1
fi

# --- Select Date ---
if [[ -z "$DATE" ]]; then
    declare -A DATE_SET=()
    for DB_NAME in "${DATABASES[@]}"; do
        while IFS= read -r archive; do
            # Extract YYYY-MM-DD from filename: ${DB_NAME}_YYYY-MM-DD_HH-MM-SS.tar.gz
            d=$(basename "$archive" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1 || true)
            [[ -n "$d" ]] && DATE_SET["$d"]=1
        done < <(find "$BACKUP_BASE/$DB_NAME" -name "*.tar.gz" 2>/dev/null || true)
    done

    mapfile -t AVAILABLE_DATES < <(printf '%s\n' "${!DATE_SET[@]}" | sort -r)

    if [[ ${#AVAILABLE_DATES[@]} -eq 0 ]]; then
        echo "No backups found for selected databases."
        exit 1
    fi

    DATE=$(pick_one "Select backup date" "${AVAILABLE_DATES[@]}")

    if [[ ! "$DATE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        echo "Error: Selected date is invalid: '$DATE'"
        exit 1
    fi
fi

echo ""
echo "Restoring: ${DATABASES[*]}"
echo "From date: $DATE"
[[ ${#MONGORESTORE_EXTRA[@]} -gt 0 ]] && echo "Mode:       dry-run"
echo ""

# --- Temp dir with automatic cleanup ---
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

FAILED=()

for DB_NAME in "${DATABASES[@]}"; do
    BACKUP_DIR="$BACKUP_BASE/$DB_NAME"
    echo "=== $DB_NAME ==="

    # Find the latest archive for this DB on the given date
    ARCHIVE=$(find "$BACKUP_DIR" -name "${DB_NAME}_${DATE}_*.tar.gz" 2>/dev/null | sort | tail -1 || true)

    if [[ -z "$ARCHIVE" ]]; then
        echo "  No backup found for $DB_NAME on $DATE, skipping."
        FAILED+=("$DB_NAME (no archive for $DATE)")
        continue
    fi

    echo "  Archive: $ARCHIVE"

    # Integrity check
    echo "  Checking integrity..."
    if ! tar -tzf "$ARCHIVE" > /dev/null; then
        echo "  ERROR: Archive is corrupt or invalid."
        FAILED+=("$DB_NAME (corrupt archive)")
        continue
    fi

    # Safety snapshot of current state before overwriting (skip during dry-run)
    if [[ ${#MONGORESTORE_EXTRA[@]} -eq 0 ]]; then
        echo "  Creating safety snapshot..."
        SNAPSHOT_NAME="PRE_RESTORE_${DB_NAME}_${TIMESTAMP}"
        SNAPSHOT_DIR="$BACKUP_DIR/$SNAPSHOT_NAME"
        mkdir -p "$SNAPSHOT_DIR"

        mongodump \
            --host "localhost" \
            --username "$MONGO_USER" \
            --password "$MONGO_PASS" \
            --authenticationDatabase "$MONGO_AUTH_DB" \
            --db "$DB_NAME" \
            --out "$SNAPSHOT_DIR" \
            --quiet

        tar -czf "$BACKUP_DIR/${SNAPSHOT_NAME}.tar.gz" -C "$BACKUP_DIR" "$SNAPSHOT_NAME"
        rm -rf "$SNAPSHOT_DIR"
        echo "  Safety snapshot: $BACKUP_DIR/${SNAPSHOT_NAME}.tar.gz"
    fi

    # Extract archive
    EXTRACT_DIR="$TEMP_DIR/$DB_NAME"
    mkdir -p "$EXTRACT_DIR"
    tar -xzf "$ARCHIVE" -C "$EXTRACT_DIR"

    # Archive structure: $TIMESTAMP/$DB_NAME/ — find the DB dump directory
    RESTORE_PATH=$(find "$EXTRACT_DIR" -mindepth 2 -maxdepth 2 -type d -name "$DB_NAME" | head -1 || true)

    if [[ -z "$RESTORE_PATH" || ! -d "$RESTORE_PATH" ]]; then
        echo "  ERROR: Could not find $DB_NAME directory inside archive."
        FAILED+=("$DB_NAME (bad archive structure)")
        continue
    fi

    echo "  Restoring..."
    if mongorestore \
        --host "localhost" \
        --username "$MONGO_USER" \
        --password "$MONGO_PASS" \
        --authenticationDatabase "$MONGO_AUTH_DB" \
        --nsInclude="${DB_NAME}.*" \
        --drop \
        "${MONGORESTORE_EXTRA[@]}" \
        "$RESTORE_PATH"; then
        echo "  Done."
    else
        echo "[$(date)] Mongorestore failed for $DB_NAME!" >> "$USER_HOME/mongo_restore.log"
        FAILED+=("$DB_NAME (mongorestore failed)")
    fi

    echo ""
done

# --- Summary ---
if [[ ${#FAILED[@]} -gt 0 ]]; then
    echo "Failed:"
    printf '  - %s\n' "${FAILED[@]}"
    exit 1
fi

echo "All restores complete."
