# NAME: leopku/discourse
# VERSION: 1.3.10-official
FROM discourse/base:1.3.10

MAINTAINER leopku "https://twitter.com/leopku"

ENV GEM_SOURCE ${GEM_SOURCE:-""}
ENV DISCOURSE_SERVICE_USER ${DISCOURSE_SERVICE_USER:-discourse}
ENV DISCOURSE_SERVICE_GROUP ${DISCOURSE_SERVICE_GROUP:-discourse}
ENV DISCOURSE_SOURCE_PATH ${DISCOURSE_SOURCE_PATH:-"source/discourse"}
ENV DISCOURSE_VERSION 1.7.1
# for chinese users https://git.coding.net/leopku/discourse.git could faster than official github repo.
ENV DISCOURSE_GIT_REPO ${DISCOURSE_GIT_REPO:-https://github.com/discourse/discourse.git}

########
# Uncomment next line for speed up
########
ADD ${DISCOURSE_SOURCE_PATH} /var/www/discourse
# git clone --single-branch --depth=1 --branch v${DISCOURSE_VERSION} ${DISCOURSE_GIT_REPO}

RUN mkdir -p /etc/service/nginx && \
    mkdir -p /etc/service/unicorn && \
    mkdir -p /var/nginx/cache

ADD ./dockerize /usr/bin/
ADD ./nginx-run.sh /etc/service/nginx/run
ADD ./unicorn-run.sh /etc/service/unicorn/run
ADD ./01-nginx.sh /etc/runit/3.d/01-nginx
ADD ./02-unicorn.sh /etc/runit/3.d/02-unicorn
ADD docker-entry.sh /docker-entry.sh

RUN chmod +x /usr/bin/dockerize &&\
    chmod +x /etc/service/nginx/run &&\
    chmod +x /etc/service/unicorn/run &&\
    chmod +x /etc/runit/3.d/01-nginx &&\
    chmod +x /etc/runit/3.d/02-unicorn &&\
    chmod +x /docker-entry.sh &&\
    rm -rf /etc/nginx/sites-enabled/default &&\
    echo 'gem: --no-document' >> /etc/gemrc &&\
    useradd ${DISCOURSE_SERVICE_USER} -s /bin/bash -m -U &&\
    chown -R ${DISCOURSE_SERVICE_USER}:${DISCOURSE_SERVICE_GROUP} /var/www/discourse &&\
    if [ "${GEM_SOURCE}" != "" ]; then \
        gem source --add ${GEM_SOURCE} --remove https://rubygems.org/; \
        bundle config mirror.https://rubygems.org ${GEM_SOURCE}; \
        sed -i "s#https://rubygems.org#${GEM_SOURCE}#" /var/www/discourse/Gemfile; \
    fi &&\
    cd /var/www/discourse &&\
    LD_PRELOAD=${RUBY_ALLOCATOR} HOME=/home/discourse USER=discourse exec chpst -u discourse:www-data -U discourse:www-data \
      bundle install --deployment --without test --without development &&\
    find /var/www/discourse/vendor/bundle -name tmp -type d -exec rm -rf {} +

# USER ${DISCOURSE_SERVICE_USER}
WORKDIR /var/www/discourse

ENTRYPOINT ["/docker-entry.sh"]

EXPOSE 3000
