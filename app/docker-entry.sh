#!/bin/sh

cd /var/www/discourse
mkdir -p tmp/pids

if [ ! -f "/var/www/discourse/.db_migrated" ]; then
    echo "start db migrating"
    dockerize -wait tcp://${DISCOURSE_DB_HOST}:${DISCOURSE_DB_PORT} bundle exec rake db:migrate 1>/var/www/discourse/.db_migrated 2>&1
    echo "finish db migrating"
fi

if [ ! -f "/var/www/discourse/.assets_precompiled" ]; then
    echo "start compiling assets"
    bundle exec rake assets:precompile 1>/var/www/discourse/.assets_precompiled 2>&1
    echo "finish compiling assets"
fi

dockerize -wait tcp://${DISCOURSE_DB_HOST}:${DISCOURSE_DB_PORT} \
    -stdout /var/www/discourse/log/unicorn.stdout.log \
    -stderr /var/www/discourse/log/unicorn.stderr.log \
    /sbin/boot
#    bundle exec unicorn -E production -c config/unicorn.conf.rb

# dockerize -wait tcp://127.0.0.1:${UNICORN_PORT} /usr/sbin/nginx
