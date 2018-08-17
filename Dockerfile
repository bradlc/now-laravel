#
# PHP Dependencies
#
FROM composer:1.7 as vendor

COPY database/ database/

COPY composer.json composer.json
COPY composer.lock composer.lock

RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist

#
# Frontend
#
FROM node:8.11 as frontend

RUN mkdir -p /app/public

COPY package.json webpack.mix.js yarn.lock* /app/
COPY resources/assets/ /app/resources/assets/

WORKDIR /app

RUN yarn && yarn production

#
# Application
#
FROM zeit/wait-for:0.2 as wait

FROM alpine:3.7

COPY --from=wait /bin/wait-for /bin/wait-for

RUN set -x ; \
    addgroup -g 82 -S www-data ; \
    adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1

RUN apk add --no-cache \
    bash \
    nginx \
    php7 \
    php7-fpm \
    php7-common \
    php7-openssl \
    php7-pdo \
    php7-pdo_mysql \
    php7-pdo_sqlite \
    php7-pdo_pgsql \
    php7-mbstring \
    php7-tokenizer \
    php7-xml \
    php7-ctype \
    php7-json \
    php7-session

WORKDIR /www
COPY conf/nginx.conf /etc/nginx/
COPY conf/www.conf /etc/php7/php-fpm.d/
COPY . ./
COPY --from=vendor /app/vendor/ ./vendor/
COPY --from=frontend /app/public/js/ ./public/js/
COPY --from=frontend /app/public/css/ ./public/css/
COPY --from=frontend /app/mix-manifest.json ./mix-manifest.json
RUN chown -R www-data:www-data ./

CMD ["/bin/bash", "-c", "php-fpm7 -F & (wait-for /tmp/php7-fpm.sock && nginx) & wait -n"]
