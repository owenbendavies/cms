FROM ruby:2.3.6

ENV LANG C.UTF-8

RUN apt-get update && apt-get install --yes \
  build-essential \
  libqt5webkit5-dev \
  nodejs \
  postgresql-client \
  qt5-default \
  xvfb

WORKDIR /app

EXPOSE 3000
