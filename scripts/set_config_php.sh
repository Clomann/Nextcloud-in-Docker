SOURCE_DIR=./../nextcloud/config
CONTAINER=nextcloud_custom

mkdir -p $SOURCE_DIR

docker cp ./nextcloud/config/config.php $CONTAINER:/var/www/html/nextcloud/config/config.php

docker exec -u root $CONTAINER chown www-data:www-data /var/www/html/nextcloud/config/config.php
