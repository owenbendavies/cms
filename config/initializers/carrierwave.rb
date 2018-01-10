CarrierWave.configure do |config|
  if ENV['AWS_S3_BUCKET']
    config.fog_provider = 'fog/aws'

    bucket = ENV.fetch('AWS_S3_BUCKET')
    region = ENV.fetch('AWS_REGION')

    default_host = "https://#{bucket}.s3-#{region}.amazonaws.com"

    config.asset_host = ENV['ASSET_HOST'] || default_host

    config.fog_attributes = {
      'Cache-Control' => "public, max-age=#{1.year.to_i}"
    }

    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
      aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
      region: region
    }

    config.fog_directory = bucket
  else
    config.storage = :file
    config.base_path = '/uploads'
    config.root = Rails.root.join('public', 'uploads')
  end

  config.cache_dir = Rails.root.join('tmp', 'uploads')
end
