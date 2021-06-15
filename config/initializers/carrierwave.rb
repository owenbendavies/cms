CarrierWave.configure do |config|
  config.storage = :fog

  config.asset_host = ENV.fetch('AWS_S3_ASSET_HOST')

  config.fog_attributes = { cache_control: "public, max-age=#{Integer(1.year)}" }

  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
    aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
    region: ENV.fetch('AWS_REGION')
  }

  config.fog_directory = ENV.fetch('AWS_S3_BUCKET')

  config.fog_public = false

  config.cache_dir = Rails.root.join('tmp/uploads')
end
