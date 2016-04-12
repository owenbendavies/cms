class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  delegate :store_dir, to: :model

  def extension_white_list
    %w(jpg jpeg png)
  end

  def uuid
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
  end

  def filename
    return unless original_filename
    return model.read_attribute(mounted_as) if model.read_attribute(mounted_as)
    extension = file.extension.gsub('jpeg', 'jpg').downcase
    "#{uuid}.#{extension}"
  end

  def full_filename(for_file)
    ext = File.extname(for_file)
    base_name = for_file.chomp(ext)
    [base_name, version_name].compact.join('_') + ext
  end

  version :span12 do
    process resize_to_limit: [940, 705]
  end

  version :span8 do
    process resize_to_limit: [620, 465]
  end

  version :span4 do
    process resize_to_limit: [300, 450]
  end

  version :span3 do
    process resize_to_limit: [220, 330]
  end
end
