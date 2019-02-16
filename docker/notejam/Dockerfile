FROM alpine:3.7
ENV TERM xterm
EXPOSE 8000
MAINTAINER gianluca.mascolo@gmail.com
RUN apk add -U --no-cache --purge bash curl \
	php7-fpm php7-phar php7-cgi php7-json php7-iconv php7-mbstring php7-openssl php7-pdo_mysql \
	php7-pdo_sqlite php7-pdo php7-tokenizer php7-dom php7-ctype && \
	mkdir -p /etc/ssl/certs/ && update-ca-certificates --fresh && mkdir -p /root/code
ADD notejam.tar.xz /root/code
ADD --chown=root:root start.sh /root/start.sh
RUN chown -R root:root /root/code && cd /root/code && \
	curl -s https://getcomposer.org/installer | php && \
	php composer.phar install && \
	php app/console doctrine:schema:update --force
CMD ["/root/start.sh"]
