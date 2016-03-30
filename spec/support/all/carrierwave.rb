RSpec.configure do |config|
  config.before :each do
    Fog.mock!
    Fog::Mock.reset

    fog_directories.create(key: CarrierWave::Uploader::Base.fog_directory)
  end
end

module CarrierWaveHelpers
  extend ActiveSupport::Concern

  included do
    def fog_directories
      Fog::Storage.new(CarrierWave::Uploader::Base.fog_credentials).directories
    end

    def uploaded_files
      fog_directories.get(CarrierWave::Uploader::Base.fog_directory).files.map(&:key)
    end

    def remote_image(remote_file)
      remote_file.file.send(:file).reload
      MiniMagick::Image.read(remote_file.read)
    end
  end
end

RSpec.configuration.include CarrierWaveHelpers
