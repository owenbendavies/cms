# Web servers (compile assets)
role :web, "localhost"

# App servers (restart server)
role :app, "localhost"

# DB servers (db migrate on primary)
role :db, "localhost"
