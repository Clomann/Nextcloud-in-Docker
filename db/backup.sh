#!/bin/bash

BACKUP_DIR="/backup"
INCREMENTAL_DIR="/backup/incremental"
FULL_BACKUP_DIR="$BACKUP_DIR/full"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "================================================================================"

# Ensure backup directories exist
mkdir -p "$FULL_BACKUP_DIR" "$INCREMENTAL_DIR"

# MariaDB connection parameters
DB_SOCKET="/var/run/mysqld/mysqld.sock"
DB_USER="root"
DB_PWD="rootpassword"

# Check if a full backup exists
if [ ! -d "$FULL_BACKUP_DIR/base" ]; then
    echo "Creating first full backup..."
    mariabackup --backup --target-dir="$FULL_BACKUP_DIR/base" --socket=$DB_SOCKET --user=$DB_USER --password=$DB_PWD
    mariabackup --prepare --target-dir="$FULL_BACKUP_DIR/base"
else
    echo "Creating incremental backup..."
    mkdir -p "$INCREMENTAL_DIR/$TIMESTAMP"

    mariabackup --backup --target-dir="$INCREMENTAL_DIR/$TIMESTAMP" --incremental-basedir="$FULL_BACKUP_DIR/base" --socket=$DB_SOCKET --user=$DB_USER --password=$DB_PWD

    echo "Applying incremental backup to full backup..."
    mariabackup --prepare --target-dir="$FULL_BACKUP_DIR/base"
    mariabackup --prepare --target-dir="$FULL_BACKUP_DIR/base" --incremental-basedir="$INCREMENTAL_DIR/$TIMESTAMP"
fi

echo "Backup complete!"
