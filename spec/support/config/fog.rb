RSpec.configure do |config|
  config.before do
    Fog.mock!
    Fog::Mock.reset

    fog_directories.create(key: CarrierWave::Uploader::Base.fog_directory)
  end
end
