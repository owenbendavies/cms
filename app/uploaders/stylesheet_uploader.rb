class StylesheetUploader < CarrierWave::Uploader::Base
  def extension_white_list
    %w(css)
  end

  def asset_host
    model.asset_host
  end

  def fog_directory
    model.fog_directory
  end

  def filename
    if original_filename
      "#{Digest::MD5.hexdigest(read)}.#{file.extension}"
    end
  end
end
