RSpec.shared_context 'with carrierwave' do
  def fog_directories
    Fog::Storage.new(CarrierWave::Uploader::Base.fog_credentials).directories
  end

  def fog_directory
    fog_directories.get(CarrierWave::Uploader::Base.fog_directory)
  end

  def uploaded_files
    fog_directory.files.map(&:key)
  end

  before do
    Fog.mock!
    Fog::Mock.reset

    fog_directories.create(key: CarrierWave::Uploader::Base.fog_directory)
  end
end

RSpec.configuration.include_context 'with carrierwave'
