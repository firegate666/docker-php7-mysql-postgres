FROM php:7.3-fpm

# Install modules
RUN buildDeps="git libpq-dev libzip-dev libicu-dev libpng-dev libjpeg62-turbo-dev libfreetype6-dev libmagickwand-6.q16-dev libxslt-dev" && \
    apt-get update && \
    apt-get install -y $buildDeps --no-install-recommends

# pecl extensions
RUN buildExt="scrypt imagick" && \
    ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin && \
    pecl install $buildExt && \
    echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini && \
    echo "extension=scrypt.so" > /usr/local/etc/php/conf.d/ext-scrypt.ini

# clean up and php extensions
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-install \
        zip \
        opcache \
        pdo \
        pdo_pgsql \
        pdo_mysql \
        pgsql \
        mysqli \
        sockets \
        xsl \
        intl

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"
