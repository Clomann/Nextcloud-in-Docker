

## How to use

### MySQL
Configure root password in:
- backup.sh

## Often used commands

docker build -t nextcloud_custom .

docker-compose up -d --build

sed -i 's|^;listen.mode =.*|listen.mode = 0660|' /etc/php/8.2/fpm/pool.d/www.conf

cat /etc/php/8.2/fpm/pool.d/www.conf | grep -E 'listen|user|group|mode'

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/ssl/nextcloud.key -out nginx/ssl/nextcloud.crt \
  -subj "/CN=localhost"

### Restoring backups

mariabackup --prepare --target-dir="/backup/full/base"
mariabackup --copy-back --target-dir="/backup/full/base"

chown -R mysql:mysql /var/lib/mysql/
docker-compose restart db

FOLDER=20250201_165402 && rsync -a /backup/nextcloud_data/$FOLDER/ /var/www/html/nextcloud/data/ && rsync -a /backup/nextcloud_config/$FOLDER/ /var/www/html/nextcloud/config/

