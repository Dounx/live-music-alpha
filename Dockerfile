FROM ruby:2.7.0

RUN apt-get update -qq && apt-get install -y postgresql postgresql-client redis nodejs yarn nginx

RUN service postgresql initdb && service postgresql start && service redis start && service nginx start

RUN mkdir /live-music
WORKDIR /live-music
COPY Gemfile /live-music/Gemfile
COPY Gemfile.lock /live-music/Gemfile.lock
RUN bundle install
COPY . /live-music

# Example secret key
ENV SECRET_KEY_BASE d99ee7bae2ff012fb24a477f2393dc7508a05258fcb926cc14e0c8a1eb326ca828bac37088058551a137c496d4e1677091ef7ffc5dcc4396abc30a1f513aba32
# Example domain
ENV HOST_DOMAIN 106.12.191.133
ENV RAILS_ENV production

RUN rails db:create && rails db:migrate && rails assets:precompile

EXPOSE 80 4000

# Start the Netease API process at 0.0.0.0:4000
RUN nohup bash -c "./bin/netease-cloud-music-api &"

# Start the main process
CMD ["rails", "server"]