#!/usr/bin/env bash
# Restore OUTGROW database to Fly.io from local backup

APP_NAME=${1:-outgrow-app}
BACKUP_FILE=${2}

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: ./fly-restore.sh <app-name> <backup-file.db>"
    echo "Example: ./fly-restore.sh outgrow-app backups/outgrow-backup-20250105.db"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "✗ Backup file not found: $BACKUP_FILE"
    exit 1
fi

echo "Restoring database to Fly.io app: $APP_NAME"
echo "From: $BACKUP_FILE"
echo ""
echo "⚠️  This will overwrite the existing database on Fly.io!"
read -p "Continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Cancelled"
    exit 0
fi

# Upload backup to Fly.io
echo "Uploading database..."
fly ssh -a "$APP_NAME" sftp put "$BACKUP_FILE" /data/outgrow.db

if [ $? -eq 0 ]; then
    # Set correct permissions
    fly ssh -a "$APP_NAME" "chmod 644 /data/outgrow.db"
    echo "✓ Restore successful"
    echo "You may need to restart the app: fly restart -a $APP_NAME"
else
    echo "✗ Restore failed"
    exit 1
fi
