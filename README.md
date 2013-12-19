CMS
===

[![Build Status](https://travis-ci.org/obduk/cms.png?branch=master)](https://travis-ci.org/obduk/cms)
[![Dependency Status](https://gemnasium.com/obduk/cms.png)](https://gemnasium.com/obduk/cms)
[![Code Climate](https://codeclimate.com/github/obduk/cms.png)](https://codeclimate.com/github/obduk/cms)
[![Coverage Status](https://coveralls.io/repos/obduk/cms/badge.png)](https://coveralls.io/r/obduk/cms)
[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/db0f06373b732860b25a2a19dffdf503 "githalytics.com")](http://githalytics.com/obduk/cms)

A Content Management System (CMS) written with Ruby on Rails and CouchDB.
Although it is a working project, it was not created with the intention of being
a production system. Instead this has been my practice project over the years,
used for testing new ideas. For example, this project originally used MySQL,
however I switched it to use CouchDB after doing performance checks.

Some of the following concepts may be useful to look at:

* A complete example of a project using CouchDB
* Some of the Gems used, e.g. timeout
* How the tests are written, using a lot of features from rspec

Dependencies
------------

You will need a system running the following software:

* Ruby 1.9.3
* Bundler
* CouchDB
* Imagemagick

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

Cloud Files
-----------

Rackspace cloud files is used to server rails assets in production, and store
site assets in both development and production. Follow these steps to set up:

* First signup up for a [Rackspace](http://www.rackspace.com/) account.
* Update `RACKSPACE_USERNAME` and `RACKSPACE_API_KEY` in
  `config/application.yml`
* Create a container called `production_cms` and add the url to `ASSET_HOST`
  in `config/application.yml`
* Create a container called `environment_cms_host_name` for each site you create
  in the next steps and make a note of it's url, e.g. for a site with the host
  www.example.com in development mode, create a container called
  `development_cms_www_example_com`.

Setup data
----------

Currently it is only possible to create sites and users via the command line.
To set up data for your development server, run the following:

```shell
./bin/interactive
```

Next create an account to use, replacing email, password and sites with
appropriate data.

```ruby
account = Account.new
account.email = 'test@example.com'
account.password = 'password'
account.password_confirmation = 'password'
account.sites = ['localhost']
account.updated_from = '127.0.0.1'
account.save!
```

Finally create the site, replacing host and name with appropriate data, and
asset_host with the url of the Rackspace cloud files container.

```ruby
site = Site.new
site.host = 'localhost'
site.name = 'Test Site'
site.updated_from = '127.0.0.1'
site.updated_by = account.id
site.asset_host = 'http://b80c6e.rackcdn.com'
site.save!
```

Development
-----------

Run the following to spin up a server locally for development:

```shell
./bin/server
```

To test emails locally run the following:

```shell
./bin/bundle exec mailcatcher
```

See http://mailcatcher.me/ for more information.

Deployment
----------

This project can either be deployed on a Linux server like Ubuntu, or deployed
to Heroku.

Deploy to server
----------------

### Services

Sign up to the following services

* [Cloudant](https://cloudant.com/) for cloud CouchDB
* [loader.io](http://loader.io/) for load testing
* [New Relic](http://newrelic.com/) for system monitoring
* [SendGrid](http://sendgrid.com/) for sending emails
* [Sentry](https://www.getsentry.com/) for error tracking

Now add their settings to the configuration file:

```
config/application.yml
```

### Setup data

Next we need to set up the data for users and sites, run the following:

```shell
RAILS_ENV=production ./bin/interactive
```

Now follow the steps in [Setup data](#setup-data).

### Setup domains

To setup the Nginx sites run the following command:

```shell
sudo RAILS_ENV=production ./bin/rake config:nginx
```

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

### Labs

Next enable some lab features:

```shell
heroku labs:enable http-request-id
heroku labs:enable preboot
heroku labs:enable user-env-compile
```

### Addons

First remove the postgresql addon as it is not needed:

```shell
heroku addons:remove heroku-postgresql
```

Now add the following addons:

```shell
heroku addons:add cloudant
heroku addons:add loaderio
heroku addons:add newrelic
heroku addons:add papertrail
heroku addons:add sendgrid
heroku addons:add sentry
```

Now run figaro to set Heroku config:

```shell
RAILS_ENV=production ./bin/rake figaro:heroku
heroku config:set HEROKU=true
```

### Setup data

Next we need to set up the data for users and sites, run the following:

```shell
heroku run ./bin/interactive
```

Now follow the steps in [Setup data](#setup-data).

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
