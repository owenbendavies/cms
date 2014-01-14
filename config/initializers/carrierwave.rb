require 'carrierwave/orm/activerecord'

CarrierWave.configure do |config|
  config.storage = ENV['UPLOADS_STORAGE'].to_sym if ENV['UPLOADS_STORAGE']

  config.fog_credentials = {
    provider: ENV['FOG_PROVIDER'],
    rackspace_username: ENV['RACKSPACE_USERNAME'],
    rackspace_api_key: ENV['RACKSPACE_API_KEY'],
    rackspace_auth_url: ENV['RACKSPACE_AUTH_URL'],
  }

  config.store_dir = ENV['UPLOADS_STORE_DIR']

  config.cache_dir = "#{Rails.root}/tmp/uploads"

  config.remove_previously_stored_files_after_update = false
end
