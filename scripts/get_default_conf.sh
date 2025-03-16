#!/bin/bash

SOURCE_DIR=v/ar/www/html/nextcloud/config
TARGET_DIR=./../nextcloud/config

mkdir -p $TARGET_DIR

docker cp nextcloud_custom:$SOURCE_DIR/config.php $TARGET_DIR