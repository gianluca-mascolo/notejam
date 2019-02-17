FROM alpine:3.7
ENV TERM xterm
EXPOSE 8000
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
	echo -e '<?php\n\tphpinfo()\n?>' > /www/index.php && \
	chown -R www:www /www && \
	su -l www -c 'cd /www/code; curl -s https://getcomposer.org/installer | php' && \
	su -l www -c 'cd /www/code; php composer.phar install' && \
	su -l www -c 'cd /www/code; php app/console doctrine:schema:update --force'
CMD ["/root/start.sh"]
