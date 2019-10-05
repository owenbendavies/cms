RSpec.configure do |config|
  config.before do
    Fog.mock!
    Fog::Mock.reset

    # rubocop:disable Rails/SaveBang
    fog_directories.create(key: CarrierWave::Uploader::Base.fog_directory)
    # rubocop:enable Rails/SaveBang
  end
end
