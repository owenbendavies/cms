FROM ruby:2.3.4

RUN apt-get --quiet --quiet update && apt-get install --yes \
  imagemagick \
  libqt5webkit5-dev \
  nodejs \
  nodejs-legacy \
  postgresql-client \
  qt5-default \
  xvfb

WORKDIR /usr/src/app

COPY Gemfile* /usr/src/app/

RUN bundle install --jobs=3 --retry=3
