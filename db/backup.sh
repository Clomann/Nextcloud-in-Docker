#!/bin/bash

BACKUP_DIR="/backup"
INCREMENTAL_DIR="/backup/incremental"
FULL_BACKUP_DIR="$BACKUP_DIR/full"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

NEXTCLOUD_DATA_SRC="/var/www/html/nextcloud/data/"
NEXTCLOUD_CONFIG_SRC="/var/www/html/nextcloud/config/"
NEXTCLOUD_DATA_BACKUP="$BACKUP_DIR/nextcloud_data"
NEXTCLOUD_CONFIG_BACKUP="$BACKUP_DIR/nextcloud_config"

echo "================================================================================"

# Ensure backup directories exist
mkdir -p "$FULL_BACKUP_DIR"
mkdir -p "$INCREMENTAL_DIR"
mkdir -p "$INCREMENTAL_DIR/$TIMESTAMP"
mkdir -p "$NEXTCLOUD_DATA_BACKUP"
mkdir -p "$NEXTCLOUD_CONFIG_BACKUP"

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

### Incremental Backup for Nextcloud User Data ###
echo "Backing up Nextcloud user data incrementally..."
LAST_BACKUP=$(ls -td $NEXTCLOUD_DATA_BACKUP/* | head -1)
if [ -d "$LAST_BACKUP" ]; then
    rsync -a --delete --link-dest="$LAST_BACKUP" "$NEXTCLOUD_DATA_SRC" "$NEXTCLOUD_DATA_BACKUP/$TIMESTAMP/"
else
    rsync -a "$NEXTCLOUD_DATA_SRC" "$NEXTCLOUD_DATA_BACKUP/$TIMESTAMP/"
fi

### Incremental Backup for Nextcloud Config Files ###
echo "Backing up Nextcloud configuration incrementally..."
LAST_CONFIG_BACKUP=$(ls -td $NEXTCLOUD_CONFIG_BACKUP/* | head -1)
if [ -d "$LAST_CONFIG_BACKUP" ]; then
    rsync -a --delete --link-dest="$LAST_CONFIG_BACKUP" "$NEXTCLOUD_CONFIG_SRC" "$NEXTCLOUD_CONFIG_BACKUP/$TIMESTAMP/"
else
    rsync -a "$NEXTCLOUD_CONFIG_SRC" "$NEXTCLOUD_CONFIG_BACKUP/$TIMESTAMP/"
fi

echo "Backup complete!"
