CMS
===

[![Build Status](https://travis-ci.org/obduk/cms.png?branch=master)](https://travis-ci.org/obduk/cms)
[![Dependency Status](https://gemnasium.com/obduk/cms.png)](https://gemnasium.com/obduk/cms)
[![Code Climate](https://codeclimate.com/github/obduk/cms.png)](https://codeclimate.com/github/obduk/cms)
[![Coverage Status](https://coveralls.io/repos/obduk/cms/badge.png)](https://coveralls.io/r/obduk/cms)

A Content Management System (CMS) written with Ruby on Rails. Although it is a
working project, it was not created with the intention of being a production
system. Instead this has been my practice project over the years, used for
testing new ideas.

For an example, check out my personal website at http://www.obduk.com

Development Setup
-----------------

This project uses [Vagrant](https://www.vagrantup.com/) for development.

```shell
vagrant up
vagrant ssh
cd /vagrant
```
Run the following to setup the project (it is idempotent so can be run multiple
times).

```shell
./bin/bootstrap
```

Test
----

To run the tests run the following to make sure the system is set up correctly.

```shell
./bin/test
```

Or run one test file:

```shell
./bin/test spec/some_file.rb
```

Setup data
----------

Currently it is only possible to create sites and users via the command line.
To set up data run the following:

```shell
./bin/interactive
```

First create a user to use, replacing email, password and sites with
appropriate data.

```ruby
user = User.new
user.email = 'test@example.com'
user.password = 'password'
user.password_confirmation = 'password'
user.save!
```

Next create the site, replacing host and name with appropriate data.

```ruby
site = Site.new
site.host = 'localhost'
site.name = 'Test Site'
site.created_by = user
site.updated_by = user
site.save!
```

Next add the site to the user.

```ruby
user.sites << site
```

Development
-----------

Run the following to spin up a server locally for development:

```shell
./bin/server
```

Deployment
----------

This project uses uses [Docker](https://www.docker.com/) and
[Amazon Web Services (AWS)](http://aws.amazon.com/) for deployments.

### Services

Sign up to the following services (optional):

* [New Relic](http://newrelic.com/) for system monitoring
* [Sentry](https://www.getsentry.com/) for error tracking
* [loader.io](http://loader.io/) for load testing

### AWS Services

Set up the following AWS services:

* [CloudFront](http://aws.amazon.com/cloudfront/) for caching assets
* [ElastiCache](http://aws.amazon.com/elasticache/) for Redis server
* [Elastic Beanstalk](http://aws.amazon.com/elasticbeanstalk/) for deployments
* [IAM](http://aws.amazon.com/iam/) for S3 and SES users
* [RDS](http://aws.amazon.com/rds/) for PostgreSQL database
* [S3](http://aws.amazon.com/s3/) for storing images and css files
* [SES](http://aws.amazon.com/ses/) for sending emails

### AWS Elastic Beanstalk

To create Elastic Beanstalk environment:

* Upload `Dockerrun.aws.json`
* Set all environment variables from `config/secrets.yml.production`
