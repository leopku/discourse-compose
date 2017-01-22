#!/bin/bash
[ ! -z "$COMPRESS_BROTLI" ] && sed -i "s/. brotli/  brotli/" /etc/nginx/conf.d/discourse.conf || sed -i "s/. brotli/# brotli/" /etc/nginx/conf.d/discourse.conf