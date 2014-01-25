module CarrierWaveHelpers
  shared_context 'clear_uploaded_files' do
    before do
      FileUtils.rm_rf File.join(
        CarrierWave.root,
        CarrierWave::Uploader::Base.store_dir
      )
    end
  end

  def uploaded_files
    uploads_dir = File.join(
      CarrierWave.root,
      CarrierWave::Uploader::Base.store_dir
    )

    files = File.join(uploads_dir, '*')

    Dir.glob(files).sort.map do |file|
      file.gsub(uploads_dir + '/', '')
    end
  end
end

RSpec.configuration.include CarrierWaveHelpers
