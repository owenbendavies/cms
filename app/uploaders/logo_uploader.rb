class LogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  delegate :store_dir, to: :model

  def extension_white_list
    %w(jpg jpeg png)
  end

  def filename
    return unless original_filename

    unless version_name
      md5 = Digest::MD5.hexdigest(read)
      extension = file.extension.gsub('jpeg', 'jpg').downcase
      model.logo_filename = "#{md5}.#{extension}"
    end

    model.logo_filename
  end

  def full_filename(for_file)
    ext         = File.extname(for_file)
    base_name   = for_file.chomp(ext)
    [base_name, version_name].compact.join('_') + ext
  end

  version :header do
    process resize_to_limit: [940, 705]
  end

  version :nav, from_version: :header do
    process resize_to_limit: [60, 200]
  end
end
