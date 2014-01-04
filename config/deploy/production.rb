# Web servers (compile assets)
role :web, ENV['CAP_WEB_SERVERS']

# App servers (restart server)
role :app, ENV['CAP_APP_SERVERS']

# DB servers (db migrate on primary)
role :db, ENV['CAP_DB_SERVERS']
