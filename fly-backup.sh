#!/usr/bin/env bash
# Backup OUTGROW database from Fly.io to local machine

APP_NAME=${1:-outgrow-app}
BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/outgrow-backup-${TIMESTAMP}.db"

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "Backing up database from Fly.io app: $APP_NAME"
echo "Backup file: $BACKUP_FILE"

# Copy database from Fly.io
fly ssh -a "$APP_NAME" "cat /data/outgrow.db" > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "✓ Backup successful: $BACKUP_FILE ($SIZE)"
else
    echo "✗ Backup failed"
    exit 1
fi
