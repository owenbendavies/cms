module FogTestHelpers
  def fog_directories
    Fog::Storage.new(CarrierWave::Uploader::Base.fog_credentials).directories
  end

  def fog_directory
    fog_directories.get(CarrierWave::Uploader::Base.fog_directory)
  end

  def uploaded_files
    fog_directory.files.map(&:key)
  end
end

RSpec.configuration.include FogTestHelpers
