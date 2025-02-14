#!/bin/bash

FILE=
TARGET_DIR=/etc/ssl/certs/
SOURCE_DIR=/etc/letsencrypt/live/
CONTAINER=nginx_proxy

docker cp -r $SOURCE_DIR/$FILE $CONTAINER:$SOURCE_DIR/$FILE

docker exec -u root $CONTAINER chown -R www-data:www-data $SOURCE_DIR/$FILE
