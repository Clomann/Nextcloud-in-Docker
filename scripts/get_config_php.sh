#!/bin/bash

FILE=config.php
SOURCE_DIR=/var/www/html/nextcloud/config
TARGET_DIR=./../nextcloud/config
CONTAINER=nextcloud_custom

mkdir -p $TARGET_DIR

docker cp $CONTAINER:$SOURCE_DIR/$FILE $TARGET_DIR