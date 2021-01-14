# Dockerfile
FROM php:7.4.14-apache
# Install Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer
# Install lib
RUN apt-get update && apt-get install -y \
      unzip \
 && rm -rf /var/lib/apt/lists/*
# Install php extention
RUN docker-php-ext-install pdo_mysql curl mbstring gettext mcrypt

COPY vhost.conf /etc/apache2/sites-available/000-default.conf

# Download boxbilling
RUN mkdir -p /usr/src/boxbilling \
 && cd /usr/src/boxbilling \
 && curl -fsSL -o master.zip \
      "https://github.com/boxbilling/boxbilling/archive/master.zip" \
 && unzip master.zip \
 && rm master.zip
RUN cd src/

# Run composer
CMD ["composer", "install"]

RUN chown -R www-data:www-data /usr/src/boxbilling/src \
    && a2enmod rewrite
