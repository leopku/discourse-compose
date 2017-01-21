# NAME: leopku/discourse
# VERSION: 1.3.10-official
FROM discourse/base:1.3.10

MAINTAINER leopku "https://twitter.com/leopku"

ENV DISCOURSE_VERSION 1.7.1
ENV GEM_SOURCE ${GEM_SOURCE:-https://mirrors.tuna.tsinghua.edu.cn/rubygems/}

ENV DISCOURSE_REDIS_HOST ${DISCOURSE_REDIS_HOST:-redis}
ENV DISCOURSE_REDIS_PORT ${DISCOURSE_REDIS_PORT:-6379}
ENV DISCOURSE_DB_HOST ${DISCOURSE_DB_HOST:-db}
ENV DISCOURSE_DB_PORT ${DISCOURSE_DB_PORT:-5432}
ENV DISCOURSE_SMTP_HOST ${DISCOURSE_SMTP_HOST:-mail}
ENV DISCOURSE_SMTP_ADDRESS ${DISCOURSE_SMTP_ADDRESS:-mail}
ENV DISCOURSE_SMTP_PORT ${DISCOURSE_SMTP_PORT:-1025}
ENV DISCOURSE_SERVICE_USER ${DISCOURSE_SERVICE_USER:-discourse}
ENV DISCOURSE_SERVICE_GROUP ${DISCOURSE_SERVICE_GROUP:-discourse}

ENV DISCOURSE_SOURCE_PATH ${DISCOURSE_SOURCE_PATH:-"source/discourse"}
ENV DISCOURSE_GIT_REPO ${DISCOURSE_GIT_REPO:-https://git.coding.net/leopku/discourse.git}

########
# Uncomment next line for speed up
########
ADD ${DISCOURSE_SOURCE_PATH} /var/www/discourse
# git clone --single-branch --depth=1 --branch v${DISCOURSE_VERSION} ${DISCOURSE_GIT_REPO}

RUN mkdir -p /etc/service/nginx && \
    mkdir -p /var/nginx/cache

ADD ./dockerize /usr/bin/
ADD ./nginx-run.sh /etc/service/nginx/run
ADD ./01-nginx.sh /etc/runit/3.d/01-nginx
ADD docker-entry.sh /docker-entry.sh

RUN chmod +x /usr/bin/dockerize &&\
    chmod +x /etc/service/nginx/run &&\
    chmod +x /etc/runit/3.d/01-nginx &&\
    chmod +x /docker-entry.sh &&\
    rm -rf /etc/nginx/sites-enabled/default &&\
    useradd ${DISCOURSE_SERVICE_USER} -s /bin/bash -m -U &&\
    echo 'gem: --no-document' >> /etc/gemrc &&\
    chown -R ${DISCOURSE_SERVICE_USER}:${DISCOURSE_SERVICE_GROUP} /var/www/discourse &&\
    gem source --add ${GEM_SOURCE} --remove https://rubygems.org/ &&\
    bundle config mirror.https://rubygems.org ${GEM_SOURCE} &&\
    sudo -u ${DISCOURSE_SERVICE_USER} sed -i "s#https://rubygems.org#${GEM_SOURCE}#" /var/www/discourse/Gemfile &&\
    cd /var/www/discourse &&\
    sudo -u discourse bundle install --deployment \
    --without test --without development &&\
    find /var/www/discourse/vendor/bundle -name tmp -type d -exec rm -rf {} +

USER ${DISCOURSE_SERVICE_USER}
WORKDIR /var/www/discourse

ENTRYPOINT ["/docker-entry.sh"]

EXPOSE 3000
