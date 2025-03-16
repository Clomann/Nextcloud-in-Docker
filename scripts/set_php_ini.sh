#!/bin/bash

FILE=php.ini
SOURCE_DIR=./../nextcloud/php
TARGET_DIR=/etc/php/8.2/fpm/
CONTAINER=nextcloud_custom

docker cp $SOURCE_DIR/$FILE $CONTAINER:$TARGET_DIR/$FILE

docker exec -u root $CONTAINER chown www-data:www-data $TARGET_DIR/$FILE
