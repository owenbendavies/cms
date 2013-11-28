# New Relic notification
require 'new_relic/recipes'
after "deploy:update", "newrelic:notice_deployment"

# Update Cron
set :whenever_command, "bundle exec whenever"
require 'whenever/capistrano'

# Web servers (compile assets)
role :web, ENV['CAP_WEB_SERVERS']

# App servers (restart server)
role :app, ENV['CAP_APP_SERVERS']

# DB servers (db migrate on primary)
role :db, ENV['CAP_DB_SERVERS']
