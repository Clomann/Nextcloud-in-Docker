export APP_HTTP_PORT=8080
export APP_HTTPS_PORT=8443

export MYSQL_ROOT_PASSWORD=rootpassword
export MYSQL_DATABASE=nextcloud
export MYSQL_USER=nextclouduser
export MYSQL_PASSWORD=yourpassword

docker-compose -f docker-compose.yaml up -d