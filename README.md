# CMS

[![CircleCI](https://circleci.com/gh/obduk/cms.svg?style=svg)](https://circleci.com/gh/obduk/cms)

A Content Management System (CMS) written with Ruby on Rails. Although it is a
working project, it was not created with the intention of being a production
system. Instead this has been my practice project over the years, used for
testing new ideas.

## Development

### Mac installation

1. https://brew.sh/ to install Homebrew
1. `brew install heroku imagemagick node postgresql rbenv yarn` to install dependencies
1. `brew services start --all` to start database
1. `createuser --createdb postgres` to create database user
1. `rbenv install` to install ruby version
1. `./bin/setup` to set up the system

### Test

1. `./bin/test` to run all tests
1. `./bin/test spec/models/user_spec.rb` to run one test or folder
1. `./bin/quality` to run just the code quality checks

### Local server

1. `./bin/run` to start services
1. http://localhost:3000/ to access the site
1. http://localhost:3000/graphiql to view GraphQL api
