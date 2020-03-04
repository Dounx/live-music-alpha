FROM ruby:2.7-alpine

MAINTAINER Dounx "https://github.com/Dounx"
RUN gem install bundler
RUN apk --update add ca-certificates npm tzdata imagemagick &&\
  apk add --virtual .builddeps build-base ruby-dev libc-dev openssl linux-headers postgresql-dev \
  libxml2-dev libxslt-dev git curl nginx nginx-mod-http-image-filter nginx-mod-http-geoip &&\
  rm -rf /etc/nginx/*

RUN npm install -g yarn

RUN curl https://get.acme.sh | sh

ENV RAILS_ENV production
ENV SECRET_KEY_BASE fake_secure_for_compile
ENV HOST_DOMAIN fake_domain_for_compile

WORKDIR /home/app/live-music

VOLUME /home/app/live-music/plugins

RUN mkdir -p /home/app &&\
  find / -type f -iname '*.apk-new' -delete &&\
  rm -rf '/var/cache/apk/*' '/tmp/*'

ADD Gemfile Gemfile.lock /home/app/live-music/
RUN gem install puma
RUN bundle config set deployment 'true' &&\
  bundle install --jobs 20 --retry 5 &&\
  find /home/app/live-music/vendor/bundle -name tmp -type d -exec rm -rf {} +
ADD . /home/app/live-music
ADD ./config/nginx/ /etc/nginx

RUN rm -Rf /home/app/live-music/vendor/cache

RUN bundle exec rails assets:precompile