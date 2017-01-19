#!/bin/bash

cd /var/www/discourse
sudo -u discourse bundle exec rake db:migrate
sudo -u discourse bundle exec rails s
