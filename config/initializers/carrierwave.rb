CarrierWave.configure do |config|
  if ENV['AWS_S3_BUCKET']
    config.storage = :fog

    default_host = "https://#{ENV['AWS_S3_BUCKET']}.s3-#{ENV['AWS_REGION']}.amazonaws.com"
    config.asset_host = ENV['AWS_S3_HOST'] || default_host

    config.fog_attributes = {
      'Cache-Control' => Rails.application.config.static_cache_control
    }

    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_IAM_KEY'],
      aws_secret_access_key: ENV['AWS_IAM_SECRET'],
      region: ENV['AWS_REGION']
    }

    config.fog_directory = ENV['AWS_S3_BUCKET']
  else
    config.storage = :file
    config.base_path = '/uploads'
    config.root = Rails.root.join('public', 'uploads')
  end

  config.cache_dir = "#{Rails.root}/tmp/uploads"
end
