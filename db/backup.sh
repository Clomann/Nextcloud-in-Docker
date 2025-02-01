#!/bin/bash

BACKUP_DIR="/backup"
INCREMENTAL_DIR="/backup/incremental"
FULL_BACKUP_DIR="$BACKUP_DIR/full"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Ensure backup directories exist
mkdir -p "$FULL_BACKUP_DIR" "$INCREMENTAL_DIR"

# MariaDB connection parameters
DB_SOCKET="/var/run/mysqld/mysqld.sock"
DB_USER="root"
DB_PASSWORD="$MYSQL_ROOT_PASSWORD"

# Check if a full backup exists
if [ ! -d "$FULL_BACKUP_DIR/base" ]; then
    echo "Creating first full backup..."
    mariabackup --backup --target-dir="$FULL_BACKUP_DIR/base" --socket=$DB_SOCKET --user=$DB_USER --password=$DB_PASSWORD
    mariabackup --prepare --target-dir="$FULL_BACKUP_DIR/base"
else
    echo "Creating incremental backup..."
    mariabackup --backup --target-dir="$INCREMENTAL_DIR/$TIMESTAMP" --incremental-basedir="$FULL_BACKUP_DIR/base" --socket=$DB_SOCKET --user=$DB_USER --password=$DB_PASSWORD
    mariabackup --prepare --target-dir="$INCREMENTAL_DIR/$TIMESTAMP" --incremental-basedir="$FULL_BACKUP_DIR/base"
fi

echo "Backup complete!"
