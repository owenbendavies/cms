class StylesheetUploader < CarrierWave::Uploader::Base
  delegate :store_dir, to: :model

  def extension_white_list
    %w(css)
  end

  def uuid
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
  end

  def filename
    return unless original_filename
    return model.read_attribute(mounted_as) if model.read_attribute(mounted_as)
    "#{uuid}.#{file.extension}"
  end
end
