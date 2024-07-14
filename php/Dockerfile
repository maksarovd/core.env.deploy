ARG VERSION_PHP=php:8.2-fpm

FROM $VERSION_PHP

RUN apt-get -y update --fix-missing && \
    apt-get upgrade -y && \
    apt-get install -y ca-certificates \
                       ffmpeg \
                       libwebp-dev \
                       libicu-dev \
                       libzip-dev \
                       zlib1g-dev \
                       libxslt-dev \
                       libpng-dev \
                       libpq-dev \
                       libfreetype6-dev \
                       libjpeg62-turbo-dev \
                       libz-dev  \
                       libmemcached-dev \
                       zlib1g-dev \
                       libssl-dev \
                       libtidy-dev \
                       #Устанавливаем memcached
                       memcached  \
                       libmemcached-tools\
                       libmagickwand-dev --no-install-recommends \
                       #Устанавливаем mc
                       mc \
                       gettext-base \
                       #Устанавливаем openssh-client
                       openssh-client \
                       #Устанавливаем git
                       git \
                       #Устанавливаем cron
                       cron \
                       #Устанавливаем wget
                       wget \
                       gnupg

#Настраиваем расширения php
RUN docker-php-ext-configure intl && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-configure pcntl --enable-pcntl

#Устанавливаем расширения php
RUN docker-php-ext-install bcmath && \
    docker-php-ext-install intl && \
    docker-php-ext-install iconv && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install pdo_pgsql && \
    docker-php-ext-install pgsql && \
    docker-php-ext-install pcntl && \
    docker-php-ext-install gd && \
    docker-php-ext-install sockets && \
    docker-php-ext-install soap && \
    docker-php-ext-install tidy && \
    docker-php-ext-install xsl && \
    docker-php-ext-install zip


#Устанавливаем расширения php через pecl
RUN pecl install pcov && \
    pecl install xdebug && \
    pecl install redis && \
    pecl install imagick && \
    pecl install memcached && \
    pecl install mongodb

#Активируем расширения php
RUN docker-php-ext-enable pcov && \
    docker-php-ext-enable xdebug && \
    docker-php-ext-enable redis && \
    docker-php-ext-enable imagick && \
    docker-php-ext-enable memcached && \
    docker-php-ext-enable mongodb


#Установка через curl
    #Установка composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.25 && \
    composer self-update --2 && \
    #Установка symfony-cli
    curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash && apt install -y symfony-cli && \
    #Установка Node 20
    curl -o- 'https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh' | bash && \
    cd ~/../root/.nvm/ && bash nvm.sh && bash -l -c "nvm install 20"


#Установка через wget
     #Установка mongosh
RUN wget https://downloads.mongodb.com/compass/mongodb-mongosh_2.0.0_amd64.deb && \
    apt-get update && apt-get install -y ./mongodb-mongosh_2.0.0_amd64.deb

#Установка через https
    #Установка amqp
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync && install-php-extensions amqp