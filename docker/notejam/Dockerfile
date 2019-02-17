FROM alpine:3.7
ENV TERM xterm
ENV SYMFONY_ENV prod
EXPOSE 80
MAINTAINER gianluca.mascolo@gmail.com
RUN apk add -U --no-cache --purge bash curl nginx tzdata \
	php7-fpm php7-phar php7-cgi php7-json php7-iconv php7-mbstring php7-openssl php7-pdo_mysql \
	php7-pdo_sqlite php7-pdo php7-tokenizer php7-dom php7-ctype php7-session php7-xml php7-simplexml php7-posix php7-intl && \
	mkdir -p /etc/ssl/certs/ && update-ca-certificates --fresh &&  adduser -D -g 'www' www && \
        mkdir -p /www/code && chown -R www:www /var/lib/nginx
ADD notejam.tar.xz /www/code
ADD --chown=root:root start.sh /root/start.sh
ADD --chown=root:root www.conf /etc/php7/php-fpm.d/www.conf
ADD --chown=root:root nginx.conf /etc/nginx/nginx.conf
RUN cp /usr/share/zoneinfo/UTC /etc/localtime && echo UTC > /etc/timezone && \
	sed -i "s|;*date.timezone =.*|date.timezone = UTC|i" /etc/php7/php.ini && \
	sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php7/php-fpm.conf && \
	chown -R www:www /www && \
	su -l www -c 'cd /www/code; curl -s https://getcomposer.org/installer | php' && \
	su -l www -c 'cd /www/code; SYMFONY_ENV=prod php composer.phar install --no-dev --optimize-autoloader' && \
	su -l www -c 'cd /www/code; SYMFONY_ENV=prod php app/check.php' && \
	su -l www -c 'cd /www/code; SYMFONY_ENV=prod php app/console cache:clear --env=prod --no-debug' && \
	su -l www -c 'cd /www/code; SYMFONY_ENV=prod php app/console doctrine:schema:update --force' && \
	su -l www -c 'cd /www/code; SYMFONY_ENV=prod php app/console assetic:dump --env=prod --no-debug' && \
	su -l www -c 'cd /www/code; SYMFONY_ENV=prod php app/console assets:install --env=prod --no-debug' && \
        rm -f /www/code/web/app_dev.php && mv /www/code/web/app.php /www/code/web/index.php
CMD ["/root/start.sh"]
