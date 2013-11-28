require 'spec_helper'
require 'rake'

describe 'db' do
  describe 'backup' do
    let(:backup_database) {
      CouchPotato.couchrest_database_for_name ENV['COUCHDB_BACKUP_URL']
    }

    let(:main_database) { CouchPotato.couchrest_database }

    it 'creates backup database' do
      backup_database.delete! rescue RestClient::ResourceNotFound

      expect {
        backup_database.info
      }.to raise_error RestClient::ResourceNotFound

      rake = Rake::Application.new
      Rake.application = rake
      load Rails.root.join 'lib/tasks/db.rake'
      Rake::Task.define_task(:environment)
      rake['db:backup'].invoke

      expect {
        backup_database.info
      }.not_to raise_error
    end

    it 'replicates all documents' do
      backup_database.recreate!

      main_database.documents['total_rows'].should eq 0
      backup_database.documents['total_rows'].should eq 0

      FactoryGirl.create(:account)

      main_database.documents['total_rows'].should eq 1
      backup_database.documents['total_rows'].should eq 0

      rake = Rake::Application.new
      Rake.application = rake
      load Rails.root.join 'lib/tasks/db.rake'
      Rake::Task.define_task(:environment)
      rake['db:backup'].invoke

      main_database.documents['total_rows'].should eq 1
      backup_database.documents['total_rows'].should eq 1
    end
  end
end
