class ImageUploader < BaseUploader
  include CarrierWave::MiniMagick

  def extension_white_list
    %w(jpg jpeg png)
  end

  def store_dir
    'images'
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
