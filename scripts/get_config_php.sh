#!/bin/bash

TARGET_DIR=./../nextcloud/config

mkdir -p $TARGET_DIR

docker cp nextcloud_custom:/var/www/html/nextcloud/config/config.php $TARGET_DIR