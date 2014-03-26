CMS
===

[![Build Status](https://travis-ci.org/obduk/cms.png?branch=master)](https://travis-ci.org/obduk/cms)
[![Dependency Status](https://gemnasium.com/obduk/cms.png)](https://gemnasium.com/obduk/cms)
[![Code Climate](https://codeclimate.com/github/obduk/cms.png)](https://codeclimate.com/github/obduk/cms)
[![Coverage Status](https://coveralls.io/repos/obduk/cms/badge.png)](https://coveralls.io/r/obduk/cms)

A Content Management System (CMS) written with Ruby on Rails and CouchDB.
Although it is a working project, it was not created with the intention of being
a production system. Instead this has been my practice project over the years,
used for testing new ideas. For example, this project originally used MySQL,
however I switched it to use CouchDB after doing performance checks.

Some of the following concepts may be useful to look at:

* A complete example of a project using CouchDB
* Some of the Gems used, e.g. timeout
* How the tests are written, using a lot of features from rspec

For an example, check out my personal website at http://www.obduk.com

![Screen Shot](https://raw.github.com/obduk/cms/master/screen_shot.png)

Dependencies
------------

You will need a system running the following software:

* Ruby
* Bundler
* CouchDB
* Imagemagick
* Mailcatcher (For development)

For more detailed dependencies, this is the project I use for setting up my
development and live server: https://github.com/obduk/server_setup

Setup
-----

First run the following to setup the project.

```shell
./bin/bootstrap
```

Test
----

To run the tests run the following to make sure your system is set up correctly.

```shell
./bin/test
```

Or you can run one test file:

```shell
./bin/test spec/some_file.rb
```

Setup data
----------

Currently it is only possible to create sites and users via the command line.
To set up data for your development server, run the following:

```shell
./bin/interactive
```

First we need to create the features object, used to enable or disable features.

```ruby
Features.new.save!
```

Next create an account to use, replacing email, password and sites with
appropriate data.

```ruby
account = Account.new
account.email = 'test@example.com'
account.password = 'password'
account.password_confirmation = 'password'
account.sites = ['localhost']
account.save!
```

Finally create the site, replacing host and name with appropriate data.

```ruby
site = Site.new
site.host = 'localhost'
site.name = 'Test Site'
site.updated_by = account.id
site.save!
```

Development
-----------

Run the following to spin up a server locally for development:

```shell
./bin/server
```

Deployment
----------

This project can either be deployed on a Linux server like Ubuntu, or deployed
to Heroku.

Cloud Files
-----------

Rackspace cloud files is used to store and serve site images and stylesheets in
production. Follow these steps to set up:

* First signup up for a [Rackspace](http://www.rackspace.com/) account.
* Update `RACKSPACE_USERNAME` and `RACKSPACE_API_KEY` in
  `config/application.yml` fore Heroku, or
  `config/deploy/production.application.yml` for server.
* Create a container called `environment_cms_host_name` for each site you create
  in the next steps and make a note of it's url, e.g. for a site with the host
  www.example.com in development mode, create a container called
  `development_cms_www_example_com`.
* When adding sites, set the `asset_host`, e.g.
  `site.asset_host = 'http://b80c6e.rackcdn.com'`

Amazon CloudFront
-----------------

It is recommended to set up a Amazon CloudFront distribution to serve the Rails
assets for your site. Once set up, add the distribution url to `ASSET_HOST` in
`config/application.yml` for Heroku or
`config/deploy/production.application.yml` for server.

Deploy to server
----------------

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

Deploy to Heroku
----------------

### Setup

First make sure you are logged into Heroku:

```shell
heroku login
```

Next either create a new app on Heroku, or add an existing remote:

```shell
heroku create name
heroku git:remote -a name
```

### Addons

Now add the following addons:

```shell
heroku addons:add cloudant
heroku addons:add loaderio
heroku addons:add logentries
heroku addons:add newrelic
heroku addons:add sendgrid
heroku addons:add sentry
```

Now run figaro to set Heroku config:

```shell
RAILS_ENV=production ./bin/rake figaro:heroku
```

### Setup domains

Next add each domain you have:

```shell
heroku domains:add www.example.com
```

### Deploy

First bring up the logs to keep an eye on:

```shell
heroku logs -t
```

Now use git to push to Heroku:

```shell
git push heroku master
```

### Remove addon

Now remove the postgresql addon as it is not needed:

```shell
heroku addons:remove heroku-postgresql
heroku config:unset DATABASE_URL
```

### Setup data

Next we need to set up the data for users and sites, run the following:

```shell
heroku run ./bin/interactive
```

Now follow the steps in [Setup data](#setup-data).
