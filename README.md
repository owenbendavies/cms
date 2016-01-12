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
1. `./bin/test` to run all tests or `./bin/test spec/some_file.rb` to run one test or folder
1. `./bin/server` to spin up a development web server
1. Visit `http://cms.dev:3000/` to access the site
1. Visit `http://cms.dev:3000/emails` to check development emails (e.g. forgot password emails)

## Deployment

Sign up to [Amazon Web Services](https://aws.amazon.com/)

1. Create an S3 bucket for storing uploaded files
1. Create an IAM user with a [policy](doc/iam_policy.json) to access the S3 bucket.
1. Follow optional steps in [doc/aws.md](doc/aws.md)

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)
