RSpec.configuration.before :each do
  Fog.mock!
  Fog::Mock.reset

  fog_directories.create(key: Rails.application.secrets.s3_bucket)
end

module CarrierWaveHelpers
  extend ActiveSupport::Concern

  included do
    let(:fog_connection) do
      Fog::Storage.new(CarrierWave::Uploader::Base.fog_credentials)
    end

    let(:fog_directories) do
      fog_connection.directories
    end

    def uploaded_files
      fog_directories.get(Rails.application.secrets.s3_bucket).files.map(&:key)
    end

    def remote_image(remote_file)
      remote_file.file.send(:file).reload
      MiniMagick::Image.read(remote_file.read)
    end
  end
end

RSpec.configuration.include CarrierWaveHelpers
