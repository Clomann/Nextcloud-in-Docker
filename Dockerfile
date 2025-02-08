FROM debian:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update 
RUN apt upgrade -y
RUN apt install -y net-tools
RUN apt install -y mariadb-server
RUN apt install -y \
    php8.2 php8.2-fpm php8.2-cli php8.2-mysql php8.2-gd php8.2-curl php8.2-xml php8.2-mbstring php8.2-zip php8.2-bz2 php8.2-intl php8.2-bcmath php8.2-gmp php-imagick
RUN apt install -y curl unzip bzip2
RUN rm -rf /var/lib/apt/lists/*

# Download and extract Nextcloud
WORKDIR /var/www/html
RUN rm nextcloud.tar.bz2 || :
RUN curl -o nextcloud.tar.bz2 https://download.nextcloud.com/server/releases/latest.tar.bz2 && \
    tar -xjf nextcloud.tar.bz2  && \ 
    rm nextcloud.tar.bz2

# Create the data directory inside the image
RUN mkdir -p /var/www/html/nextcloud/data

# Set correct permissions
RUN chown -R www-data:www-data nextcloud
RUN chmod -R 755 nextcloud

# Configure PHP
RUN sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/8.2/fpm/php.ini && \
    sed -i 's/upload_max_filesize = .*/upload_max_filesize = 512M/' /etc/php/8.2/fpm/php.ini && \
    sed -i 's/post_max_size = .*/post_max_size = 512M/' /etc/php/8.2/fpm/php.ini && \
    sed -i 's/max_execution_time = .*/max_execution_time = 360/' /etc/php/8.2/fpm/php.ini && \
    sed -i 's|^;listen.mode =.*|listen.mode = 0660|' /etc/php/8.2/fpm/pool.d/www.conf


# Expose PHP-FPM port (NGINX will connect to it)
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm8.2", "-F"]