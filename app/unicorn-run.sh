#!/bin/bash
exec 2>&1
# redis
# postgres
cd /var/www/discourse
LD_PRELOAD=${RUBY_ALLOCATOR} HOME=/home/discourse USER=discourse exec chpst -u discourse:www-data -U discourse:www-data bundle exec config/unicorn_launcher -E production -c config/unicorn.conf.rb
