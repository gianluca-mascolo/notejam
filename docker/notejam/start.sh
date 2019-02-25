#!/bin/bash
if ( [ -z ${SYMFONY_ENV+x} ] || [ -z ${SYMFONY__DATABASE__DRIVER+x} ] || [ -z ${SYMFONY__DATABASE__HOST+x} ] || [ -z ${SYMFONY__DATABASE__PORT+x} ] || [ -z ${SYMFONY__DATABASE__NAME+x} ] || [ -z ${SYMFONY__DATABASE__USER+x} ] || [ -z ${SYMFONY__DATABASE__PASSWORD+x} ] ); then {
 echo "Missing parameters"
 exit 1
}
fi

envsubst '$SYMFONY_ENV,$SYMFONY__DATABASE__DRIVER,$SYMFONY__DATABASE__HOST,$SYMFONY__DATABASE__PORT,$SYMFONY__DATABASE__NAME,$SYMFONY__DATABASE__USER,$SYMFONY__DATABASE__PASSWORD' < /etc/nginx/nginx.conf.tmpl > /etc/nginx/nginx.conf
su -s /bin/bash www -c 'cd /www/code; php composer.phar install --no-dev --optimize-autoloader'
su -s /bin/bash www -c 'cd /www/code; php app/check.php'
su -s /bin/bash www -c 'cd /www/code; php app/console cache:clear --env=$SYMFONY_ENV --no-debug'
su -s /bin/bash www -c 'cd /www/code; php app/console assetic:dump --env=$SYMFONY_ENV --no-debug'
su -s /bin/bash www -c 'cd /www/code; php app/console assets:install --env=$SYMFONY_ENV --no-debug'
su -s /bin/bash www -c 'cd /www/code; php app/console doctrine:schema:update --force'
touch /www/code/app/logs/prod.log
chown www:www /www/code/app/logs/prod.log
php-fpm7
nginx
tail  -f /www/code/app/logs/prod.log
