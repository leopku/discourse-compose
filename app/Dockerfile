# NAME: leopku/discourse
# VERSION: official-1.3.10
FROM discourse/base:1.3.10

MAINTAINER leopku "https://twitter.com/leopku"

ENV DISCOURSE_VERSION 1.7.1
ENV GEM_SOURCE=${GEM_SOURCE:-https://mirrors.tuna.tsinghua.edu.cn/rubygems/}

ARG DISCOURSE_GIT_REPO=https://git.coding.net/leopku/discourse.git

RUN	mkdir -p /var/www &&\
	cd /var/www
ADD discourse /var/www/discourse

RUN useradd discourse -s /bin/bash -m -U &&\
	echo 'gem: --no-document' >> /etc/gemrc &&\
	# git clone --single-branch --depth=1 --branch v${DISCOURSE_VERSION} ${DISCOURSE_GIT_REPO} &&\
	chown -R discourse:discourse /var/www/discourse &&\
	# sudo -u discourse gem source --add ${GEM_SOURCE} --remove https://rubygems.org/ &&\
	# sudo -u discourse bundle config mirror.https://rubygems.org ${GEM_SOURCE} && \
	sudo -u discourse sed -i "s#https://rubygems.org#${GEM_SOURCE}#" /var/www/discourse/Gemfile &&\
	cd /var/www/discourse &&\
	sudo -u discourse bundle install --deployment \
		--without test --without development &&\
	find /var/www/discourse/vendor/bundle -name tmp -type d -exec rm -rf {} +

COPY docker-entry.sh /
RUN chmod +x /docker-entry.sh

ENTRYPOINT ["/docker-entry.sh"]

EXPOSE 3000
