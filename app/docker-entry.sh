#!/bin/sh

cd /var/www/discourse
sudo -u discourse mkdir -p tmp/pids
sudo -u discourse mkdir -p tmp/run

MIGRATION_LOG="/var/www/discourse/tmp/run/.db_migrated"
ASSETS_LOG="/var/www/discourse/tmp/run/.assets_precompiled"

if [ ! -f ${MIGRATION_LOG} ]; then
    echo "start db migrating"
    dockerize -wait tcp://${DISCOURSE_DB_HOST}:${DISCOURSE_DB_PORT} LD_PRELOAD=${RUBY_ALLOCATOR} HOME=/home/discourse USER=discourse exec chpst -u discourse:www-data -U discourse:www-data bundle exec rake db:migrate 1>${MIGRATION_LOG} 2>&1
    echo "finish db migrating"
fi

if [ ! -f ${ASSETS_LOG} ]; then
    echo "start compiling assets"
    LD_PRELOAD=${RUBY_ALLOCATOR} HOME=/home/discourse USER=discourse exec chpst -u discourse:www-data -U discourse:www-data bundle exec rake assets:precompile 1>${ASSETS_LOG} 2>&1
    echo "finish compiling assets"
fi

dockerize -wait tcp://${DISCOURSE_DB_HOST}:${DISCOURSE_DB_PORT} \
    -stdout /var/www/discourse/log/unicorn.stdout.log \
    -stderr /var/www/discourse/log/unicorn.stderr.log \
    /sbin/boot
#    bundle exec unicorn -E production -c config/unicorn.conf.rb

# dockerize -wait tcp://127.0.0.1:${UNICORN_PORT} /usr/sbin/nginx
