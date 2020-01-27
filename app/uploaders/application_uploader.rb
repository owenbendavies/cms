class ApplicationUploader < CarrierWave::Uploader::Base
  delegate :public_url, to: :file

  def uuid
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
  end

  def filename
    return unless original_filename
    return model.read_attribute(:filename) if model.read_attribute(:filename)

    extension = file.extension.downcase.gsub('jpeg', 'jpg')
    "#{uuid}.#{extension}"
  end

  def full_filename(for_file)
    ext = File.extname(for_file)
    base_name = for_file.chomp(ext)
    sub_name = version_name || 'original'
    [base_name, sub_name].join('/') + ext
  end
end
