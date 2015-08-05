RSpec.configuration.before :each do
  FileUtils.rm_rf File.join(
    CarrierWave.root,
    Rails.application.secrets.uploads_store_dir
  )
end

module CarrierWaveHelpers
  def uploaded_files
    uploads_dir = File.join(
      CarrierWave.root,
      Rails.application.secrets.uploads_store_dir
    )

    files = File.join(uploads_dir, '**', '*')

    Dir.glob(files).sort.map do |file|
      file.gsub(uploads_dir + '/', '')
    end
  end
end

RSpec.configuration.include CarrierWaveHelpers
