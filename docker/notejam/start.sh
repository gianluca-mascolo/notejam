#!/bin/bash
envsubst '$SYMFONY_ENV,$SYMFONY__DATABASE__DRIVER,$SYMFONY__DATABASE__HOST,$SYMFONY__DATABASE__PORT,$SYMFONY__DATABASE__NAME,$SYMFONY__DATABASE__USER,$SYMFONY__DATABASE__PASSWORD' < /etc/nginx/nginx.conf.tmpl > /etc/nginx/nginx.conf
su -s /bin/bash www -c 'cd /www/code; php app/console doctrine:schema:update --force'
touch /www/code/app/logs/prod.log
chown www:www /www/code/app/logs/prod.log
php-fpm7
nginx
tail  -f /www/code/app/logs/prod.log
