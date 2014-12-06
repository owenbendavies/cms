CarrierWave.configure do |config|
  uploads_storage = Rails.application.secrets.uploads_storage

  config.storage = uploads_storage.to_sym if uploads_storage

  if uploads_storage == 'fog'
    config.asset_host = Rails.application.secrets.aws_host

    config.fog_attributes = {
      'Cache-Control' => "public, max-age=#{365.day.to_i}"
    }

    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.secrets.aws_key,
      aws_secret_access_key: Rails.application.secrets.aws_secret,
      region: Rails.application.secrets.aws_region,
    }

    config.fog_directory = Rails.application.secrets.aws_bucket
  end

  config.store_dir = Rails.application.secrets.uploads_store_dir

  config.cache_dir = "#{Rails.root}/tmp/uploads"
end
