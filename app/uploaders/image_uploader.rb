class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def extension_white_list
    %w(jpg jpeg png)
  end

  def filename
    if original_filename
      unless version_name
        md5 = Digest::MD5.hexdigest(read)
        extension = file.extension.gsub('jpeg', 'jpg').downcase
        model.filename = "#{md5}.#{extension}"
      end

      return model.filename
    end
  end

  def full_filename(for_file)
    ext         = File.extname(for_file)
    base_name   = for_file.chomp(ext)
    [base_name, version_name].compact.join('_') + ext
  end

  def store_dir
    model.store_dir
  end

  version :span12 do
    process resize_to_limit: [940, 705]
  end

  version :span10, from_version: :span12 do
    process resize_to_limit: [780, 585]
  end

  version :span8, from_version: :span10 do
    process resize_to_limit: [620, 465]
  end

  version :span4, from_version: :span8 do
    process resize_to_limit: [300, 450]
  end

  version :span3, from_version: :span4 do
    process resize_to_limit: [220, 330]
  end

  version :span2, from_version: :span3 do
    process resize_to_fill: [140, 140]
  end

  version :span1, from_version: :span2 do
    process resize_to_fill: [60, 60]
  end
end
