Discourse for docker compose and rancher compose

https://github.com/leopku/discourse-compose

# WHY this project born?

A set of tools for docker were shipped with [offical Discourse docker release](https://github.com/discourse/discourse_docker). It do many things for user to check if Discourse can run correctly in docker and run correctly.

The main shortcoming of offical release is rebuilding, rebuilding, rebuilding. Anything changed must rebuild Discourse image. Rebuilding would take a so long time and our forum can't serve our users while rebuilding. It is not acceptable for our site.

The second thing made me to write a compose version for building a Discourse site is now we were using [Rancher](http://rancher.com/) - a Platform for Operating Docker in Production - to manager all my services. After many times failured trying to run official release under rancher, I gave it up.

The last one is I need some mirrors for faster accessing and faster rebuilding. I should make these mirrors configurable.

After digging deep into what had offical release done while booting Discourse, I found another road to the same goal.

# Contributing

* Send a Pull Request with your awesome new features and bug fixes.
* Be a part of the community and help resolve [issues](https://github.com/leopku/discourse-compose/issues)
* Support the development of this project with a donation through wechat ![](21485166321.png)

# FAQ

## How to make build and run faster?

- Clone Discourse source code to local and update it frequently.
- If you are in China, you can clone the source code from one of some mirrors like https://git.coding.net/leopku/discourse.git.
- If your chose cloning inside container, you can set `DISCOURSE_GIT_REPO` env.
- Use a faster gem source by setting `GEM_SOURCE` env. `https://mirrors.tuna.tsinghua.edu.cn/rubygems/` is a choice for chinese user.

## How to configure environment variables?

1. copy `env.example` to `.env`
2. modify or add any environment variables as you want

## What is mail container?

For many guys who first launch this awesome forum, smtp and mail problems may prevent their steps.

So I add a mail container base on [mailhog](https://github.com/mailhog/mailhog) - which is a fake mail server and provides a [webui](http://YOUR_DOCKER_HOST_IP:8025) to show recieved emails.

This means you can easily do a preview setup with no actual smtp && email account with my default compose file.

BUT when in production, you MUST change `DISCOURSE_SMTP_ADDRESS` setting. You can also comment the mail container in production.

## How to add a plugin without rebuilding?

1. cd `volumes/discourse/plugins` and put source code of the plugin you desired in this folder
2. cd `volumes/discourse/tmp/run` and delete these two file `.db_migrated` and `.assets_precompiled`
3. run `docker-compose restart app`.
    
    For advanced user, run `docker-compose exec app /bin/bash`, then manualy do db migrate and assets precompiling.
    ```
    cd /var/www/discourse
    HOME=/home/discourse USER=discourse exec chpst -u discourse:www-data -U discourse:www-data bundle exec rake db:migrate
    HOME=/home/discourse USER=discourse exec chpst -u discourse:www-data -U discourse:www-data bundle exec rake assets:precompile
    sv restart unicorn
    ```

## How to change nginx config withou rebuilding?

1. Change config file in `volumes/nginx/nginx.conf` and `volumes/nginx/conf.d/discourse.conf`
2. `docker-compose exec app /bin/bash`
3. `sv restart nginx`

# Quick start

1. Prerequisites

    `docker` and `docker-compose` must installed.

2. Get source code of this project

    ```
    git clone https://github.com/leopku/discourse-compose.git
    cd discourse-compose
    ```

3. Get source code of discourse. Choose ONE way followed,

    - clone source code into Docker host (Recommended)

    ```
    git clone https://github.com/discourse/discourse.git app/source/discourse 
    git remote set-branches --add origin tests-passed
    ```

    - clone source code into docker images by commenting [Line18](https://github.com/leopku/discourse-compose/blob/master/app/Dockerfile#L18) and uncomment [Line19](https://github.com/leopku/discourse-compose/blob/master/app/Dockerfile#L19) of `app/Dockerfile`. The result may look like this,

    ```
    15 ########
    16 # Uncomment next line for speed up
    17 ########
    18 # ADD ${DISCOURSE_SOURCE_PATH} /var/www/discourse
    19 git clone --single-branch --depth=1 --branch v${DISCOURSE_VERSION} ${DISCOURSE_GIT_REPO}
    ```

    We recommend first way. You could update only changed files but not hole code every time and only do rebuilding after updating is ready. It can fast your rebuilding and make your site back to online quickly.

4. Prepare plugins 

    3.1 prepare default plugins

    ```
    cp -r app/source/discourse/plugins/* volumes/discourse/plugins/
    ```

    3.2 prepare any plugin you wanted

    ```
    cd volumes/discourse/plugin
    git clone https://github.com/discourse/docker_manager.git
    git clone https://github.com/discourse/discourse-solved.git
    ...
    ```

5. Prepare environment and config files

    ```
    cp env.example .env
    cp volumes/nginx/nginx.conf.example volumes/nginx/nginx.conf
    cp volumes/nginx/conf.d/discourse.conf.exec volumes/nginx/conf.d/discourse.conf
    ```

    Check every environment variables in IMPORTANT section to meet your actual environment

6. Run

    ```
    docker-compose up -d
    ```

7. Enjoy

    Visit http://YOUR_DOCKER_HOST_IP:10080 and have fun.

# TODOs

- [ ] Customized config parameter or file for Redis container
- [ ] Enable brotli
- [x] Version 1 format yml for rancher compose

# License
MIT
