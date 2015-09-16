# CMS

[![Build Status](https://travis-ci.org/obduk/cms.png?branch=master)](https://travis-ci.org/obduk/cms)
[![Dependency Status](https://gemnasium.com/obduk/cms.png)](https://gemnasium.com/obduk/cms)
[![Code Climate](https://codeclimate.com/github/obduk/cms.png)](https://codeclimate.com/github/obduk/cms)

A Content Management System (CMS) written with Ruby on Rails. Although it is a
working project, it was not created with the intention of being a production
system. Instead this has been my practice project over the years, used for
testing new ideas.

## Development Setup

This project uses [Vagrant](https://www.vagrantup.com/) for development.

    vagrant up
    vagrant ssh
    cd /vagrant

Run the following to setup the project (it is idempotent so can be run multiple
times).

    ./bin/bootstrap

## Test

To run the tests run the following to make sure the system is set up correctly.

    ./bin/test

Or run one test file:

    ./bin/test spec/some_file.rb

## Setup data

Currently it is only possible to create sites and users via the command line.
To set up data run the following:

    ./bin/interactive

Now input the following, replacing the relevant data:

    user = User.new
    user.admin = true
    user.name = 'Your Name'
    user.email = 'test@example.com'
    user.skip_confirmation!
    user.password = 'password'
    user.password_confirmation = 'password'
    user.save!

    Site.create!(host: 'localhost', name: 'Test Site')

## Development

Run the following to spin up a server locally for development:

    ./bin/server

## Deployment

This project can be deployed using [Heroku](https://www.heroku.com/),
[Amazon Web Services (AWS)](https://aws.amazon.com/) or
[Docker](https://www.docker.com/).

Generate a session secret for adding to settings later:

    ./bin/rake secret

Set up [Amazon CloudFront](https://aws.amazon.com/cloudfront/) for caching
assets to make the site load faster (optional).

As both Heroku and Docker can not store local persisted files, cloud file
storage is needed. Set up [Amazon S3](https://aws.amazon.com/s3/) and the
following [IAM](https://aws.amazon.com/iam/) user:

    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": ["s3:ListBucket"],
          "Resource": ["arn:aws:s3:::YOUR-BUCKET-NAME"]
        },
        {
          "Effect": "Allow",
          "Action": [
            "s3:GetObject",
            "s3:GetObjectAcl",
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:DeleteObject"
          ],
          "Resource": ["arn:aws:s3:::YOUR-BUCKET-NAME/*"]
        }
      ]
    }

### Heroku Deployment

1. Create a new app in Herkou
1. Add the following add-ons:
  * [Heroku Redis](https://elements.heroku.com/addons/heroku-redis) for storing user sessions
  * [Logentries](https://elements.heroku.com/addons/logentries) for storing logs (optional)
  * [New Relic](https://elements.heroku.com/addons/newrelic) for system monitoring (optional)
  * [Pingdom](https://elements.heroku.com/addons/pingdom) for uptime monitoring (optional)
  * [SendGrid](https://elements.heroku.com/addons/sendgrid) for sending emails (or alternative)
  * [Sentry](https://elements.heroku.com/addons/sentry) for error tracking (optional)
  * [loader.io](https://elements.heroku.com/addons/loaderio) for load testing (optional)
1. Set remaining "conifg vars" from production [config/secrets.yml](config/secrets.yml)
1. Connect to Github and enable automatic deploys
1. Migrate the database (note this will need to be run manually each deploy with migrations):
   `heroku run rake db:migrate --app YOUR-APP-NAME`
1. Set up data using `heroku run ./bin/interactive --app YOUR-APP-NAME`

### AWS Deployment

1. Sign up to the following services:
  * [New Relic](https://newrelic.com/) for system monitoring (optional)
  * [Pingdom](https://www.pingdom.com/) for uptime monitoring (optional)
  * [Sentry](https://www.getsentry.com/) for error tracking (optional)
  * [loader.io](https://loader.io/) for load testing (optional)
1. Set up the following AWS services:
  * [ElastiCache](https://aws.amazon.com/elasticache/) for storing user sessions
  * [RDS](https://aws.amazon.com/rds/) for PostgreSQL database
  * [SES](https://aws.amazon.com/ses/) for sending emails
1. Create an [Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/) application with
   [Dockerrun.aws.json](Dockerrun.aws.json)
1. Set all "Environment Properties" from production [config/secrets.yml](config/secrets.yml)
