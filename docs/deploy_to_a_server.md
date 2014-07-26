Deploy to server
================

### Setup

First setup the deploy servers in the capistrano file:

```
config/deploy/production.rb
```

### Services

Sign up to the following services

* [loader.io](http://loader.io/) for load testing
* [New Relic](http://newrelic.com/) for system monitoring
* [SendGrid](http://sendgrid.com/) for sending emails
* [Sentry](https://www.getsentry.com/) for error tracking

Now add their settings to the configuration file:

```
config/deploy/production.application.yml
```

### Setup data

Next we need to set up the data for users and sites, run the following:

```shell
RAILS_ENV=production ./bin/interactive
```

Now follow the steps in [Setup data](#setup-data).

### Deploy

Use Capistrano to deploy to your server:

```shell
./bin/bundle exec cap production deploy
```


