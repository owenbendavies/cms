class StylesheetUploader < CarrierWave::Uploader::Base
  delegate :store_dir, to: :model

  def extension_white_list
    %w(css)
  end

  def filename
    "#{SecureRandom.uuid}.#{file.extension}" if original_filename
  end
end
