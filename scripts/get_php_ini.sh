#!/bin/bash

FILE=php.ini
SOURCE_DIR=/etc/php/8.2/fpm/
TARGET_DIR=./../nextcloud/php
CONTAINER=nextcloud_custom

mkdir -p $TARGET_DIR

docker cp $CONTAINER:$SOURCE_DIR/$FILE $TARGET_DIR