#!/bin/bash

FILE=config.php
TARGET_DIR=/var/www/html/nextcloud/config
SOURCE_DIR=./../nextcloud/config
CONTAINER=nextcloud_custom

docker cp $SOURCE_DIR/$FILE $CONTAINER:$TARGET_DIR/$FILE

docker exec -u root $CONTAINER chown www-data:www-data $TARGET_DIR/$FILE
