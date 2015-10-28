# CMS

[![Build Status](https://travis-ci.org/obduk/cms.png?branch=master)](https://travis-ci.org/obduk/cms)
[![Dependency Status](https://gemnasium.com/obduk/cms.png)](https://gemnasium.com/obduk/cms)
[![Code Climate](https://codeclimate.com/github/obduk/cms.png)](https://codeclimate.com/github/obduk/cms)

A Content Management System (CMS) written with Ruby on Rails. Although it is a
working project, it was not created with the intention of being a production
system. Instead this has been my practice project over the years, used for
testing new ideas.

## Development

1. Download [Vagrant](https://www.vagrantup.com/)
1. `vagrant up` to start a virtual machine
1. `vagrant ssh` to log onto the virtual machine
1. `./bin/bootstrap` to setup the project (can be run multiple times)
1. `./bin/test` to run all tests
1. `./bin/test spec/some_file.rb` to run one test or folder
1. `./bin/interactive` to setup data
1. `./bin/server` to spin up a development web server
1. Visit `http://cms.dev:3000/` to access the site

## Setup data

Currently it is only possible to create sites and users via the command line.
Input the following, replacing the relevant data:

    user = User.new
    user.admin = true
    user.name = 'Your Name'
    user.email = 'test@example.com'
    user.skip_confirmation!
    user.password = 'password'
    user.password_confirmation = 'password'
    user.save!

    Site.create!(host: 'cms.dev', name: 'Test Site')

## Deployment

This project can be deployed using [Heroku](https://www.heroku.com/),
[Amazon Web Services (AWS)](https://aws.amazon.com/) or
[Docker](https://www.docker.com/).

1. Create an [AWS S3](https://aws.amazon.com/s3/) bucket for storing uploaded
   files
1. Create an [IAM](https://aws.amazon.com/iam/) user with a
   [policy](doc/iam_policy.json) to access the S3 bucket.
1. Create an [AWS CloudFront](https://aws.amazon.com/cloudfront/)
   distribution for caching the S3 bucket (optional)
1. Create an [AWS CloudFront](https://aws.amazon.com/cloudfront/) distribution
   for caching assets to make the site load faster (optional)
1. Sign up to the following services (or use paid for Heroku Addons):
  * [Pingdom](https://www.pingdom.com/) for uptime monitoring (optional)
  * [Sentry](https://www.getsentry.com/) for error tracking (optional)

### Heroku Deployment

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

1. Migrate the database (note this will need to be run manually each deploy with migrations):
   `heroku run rake db:migrate --app YOUR-APP-NAME`
1. Set up data using `heroku run ./bin/interactive --app YOUR-APP-NAME`

### AWS Deployment

1. `./bin/rake secret` to generate a session secret
1. Sign up to the following services:
  * [AWS ElastiCache](https://aws.amazon.com/elasticache/) for storing user sessions
  * [AWS RDS](https://aws.amazon.com/rds/) for PostgreSQL database
  * [AWS SES](https://aws.amazon.com/ses/) for sending emails
  * [New Relic](https://newrelic.com/) for system monitoring (optional)
  * [loader.io](https://loader.io/) for load testing (optional)
1. Create an [Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/) application with
   [Dockerrun.aws.json](Dockerrun.aws.json)
1. Set all "Environment Properties" from production [config/secrets.yml](config/secrets.yml)
