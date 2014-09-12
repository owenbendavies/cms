Deploy to a server
==================

### Setup

First setup the deploy servers in the capistrano file:

```
config/deploy/production.rb
```

### Services

Sign up to the following services

* Email servuce (e.g. [Amazon SES](http://aws.amazon.com/ses/), [SendGrid](http://sendgrid.com/))
* [New Relic](http://newrelic.com/) for system monitoring
* [Sentry](https://www.getsentry.com/) for error tracking
* [loader.io](http://loader.io/) for load testing

Now add their settings to the configuration file:

```
config/deploy/production.application.yml
```

### Setup data

Next we need to set up the data for users and sites, run the following:

```shell
RAILS_ENV=production ./bin/interactive
```

Now follow the steps in [Setup data](../README.md#setup-data).

### Deploy

Use Capistrano to deploy to your server:

```shell
./bin/bundle exec cap production deploy
```


