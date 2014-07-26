Deploy to Heroku
================

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

Now follow the steps in [Setup data](../README.md#setup-data).

