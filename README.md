# CMS

[![Build Status](https://travis-ci.org/obduk/cms.png?branch=master)](https://travis-ci.org/obduk/cms)
[![Dependency Status](https://gemnasium.com/obduk/cms.png)](https://gemnasium.com/obduk/cms)

A Content Management System (CMS) written with Ruby on Rails. Although it is a
working project, it was not created with the intention of being a production
system. Instead this has been my practice project over the years, used for
testing new ideas.

## Development

1. Download [Vagrant](https://www.vagrantup.com/)
1. `vagrant up` to start a virtual machine
1. `vagrant ssh` to log onto the virtual machine
1. `./bin/bootstrap` to setup the project (can be run multiple times)
1. `./bin/test` to run all tests or `./bin/test spec/some_file.rb` to run one test or folder
1. `./bin/server` to spin up a development web server
1. Visit `http://cms.dev:3000/` to access the site
1. Visit `http://cms.dev:3000/emails` to check development emails (e.g. forgot password emails)

## Deployment

This project can be deployed to [Heroku](https://www.heroku.com/) (also undocumented
[AWS](https://aws.amazon.com/) and [Docker](https://www.docker.com/)).

1. Create an [AWS S3](https://aws.amazon.com/s3/) bucket for storing uploaded
   files
1. Create an [IAM](https://aws.amazon.com/iam/) user with a
   [policy](doc/iam_policy.json) to access the S3 bucket.
1. Create an [AWS CloudFront](https://aws.amazon.com/cloudfront/)
   distribution for caching the S3 bucket (optional)
1. Create an [AWS CloudFront](https://aws.amazon.com/cloudfront/) distribution
   for caching assets to make the site load faster (optional)
1. Sign up to the following services (or use paid for Heroku Addons):
  * [Sentry](https://www.getsentry.com/) for error tracking (optional)

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)
