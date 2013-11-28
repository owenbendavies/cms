AssetSync.configure do |config|
  config.fog_provider = ENV['FOG_PROVIDER']
  config.rackspace_username = ENV['RACKSPACE_USERNAME']
  config.rackspace_api_key = ENV['RACKSPACE_API_KEY']
  config.rackspace_auth_url = ENV['RACKSPACE_AUTH_URL']
  config.fog_directory = ENV['FOG_DIRECTORY']
end
