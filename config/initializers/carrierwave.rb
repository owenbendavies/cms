CarrierWave.configure do |config|
  if Rails.application.secrets.uploads_storage
    config.storage = Rails.application.secrets.uploads_storage.to_sym
  end

  config.fog_credentials = {
    provider: Rails.application.secrets.fog_provider,
    rackspace_username: Rails.application.secrets.rackspace_username,
    rackspace_api_key: Rails.application.secrets.rackspace_api_key,
    rackspace_auth_url: Rails.application.secrets.rackspace_auth_url,
  }

  config.store_dir = Rails.application.secrets.uploads_store_dir

  config.cache_dir = "#{Rails.root}/tmp/uploads"
end
