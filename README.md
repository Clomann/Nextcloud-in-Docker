

## Often used commands

docker build -t nextcloud_custom .

docker-compose up -d --build

sed -i 's|^;listen.mode =.*|listen.mode = 0660|' /etc/php/8.2/fpm/pool.d/www.conf

cat /etc/php/8.2/fpm/pool.d/www.conf | grep -E 'listen|user|group|mode'

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/ssl/nextcloud.key -out nginx/ssl/nextcloud.crt \
  -subj "/CN=localhost"