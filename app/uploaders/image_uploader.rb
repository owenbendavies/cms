class ImageUploader < BaseUploader
  include CarrierWave::MiniMagick

  def extension_white_list
    %w(jpg jpeg png)
  end

  def store_dir
    'images'
  end

  version :processed do
    process :strip
  end

  version :span12, from_version: :processed do
    process resize_to_limit: [940, 705]
  end

  version :span8, from_version: :processed do
    process resize_to_limit: [620, 465]
  end

  version :span4, from_version: :processed do
    process resize_to_limit: [300, 450]
  end

  version :span3, from_version: :processed do
    process resize_to_limit: [220, 330]
  end

  def strip
    manipulate!(&:strip)
  end
end
