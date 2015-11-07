CarrierWave.configure do |config|
  s3_bucket = Rails.application.secrets.s3_bucket

  if s3_bucket
    config.storage = :fog

    config.asset_host = Rails.application.secrets.s3_host

    config.fog_attributes = {
      'Cache-Control' => Rails.application.config.static_cache_control
    }

    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: Rails.application.secrets.iam_key,
      aws_secret_access_key: Rails.application.secrets.iam_secret,
      region: Rails.application.secrets.s3_region
    }

    config.fog_directory = s3_bucket
  else
    config.storage = :file
    config.root = Rails.root.join('public', 'uploads')
  end

  config.cache_dir = "#{Rails.root}/tmp/uploads"
end
