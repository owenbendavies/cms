CarrierWave.configure do |config|
  if ENV['AWS_S3_BUCKET']
    bucket = ENV.fetch('AWS_S3_BUCKET')
    region = ENV.fetch('AWS_REGION')

    config.asset_host = ENV.fetch('AWS_S3_ASSET_HOST')

    config.fog_attributes = {
      cache_control: "public, max-age=#{Integer(1.year)}"
    }

    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
      aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
      region: region
    }

    config.fog_directory = bucket

    config.fog_public = false
  else
    config.storage = :file
    config.base_path = '/uploads'
    config.root = Rails.root.join('public/uploads')
  end

  config.cache_dir = Rails.root.join('tmp/uploads')
end
