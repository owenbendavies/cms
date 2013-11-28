namespace :db do
  desc "Backup CouchDB Database"
  task backup: :environment do
    backup_database = CouchPotato.couchrest_database_for_name ENV['COUCHDB_BACKUP_URL']
    backup_database.create!
    backup_database.replicate_from CouchPotato.couchrest_database
  end
end
