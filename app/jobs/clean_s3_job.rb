class CleanS3Job < BaseJob
  def perform
    clean_files.each do |file|
      error("The following file is missing: #{file}")
    end
  end

  private

  def all_files
    connection = Fog::Storage.new(CarrierWave::Uploader::Base.fog_credentials)
    directory = connection.directories.get(CarrierWave::Uploader::Base.fog_directory)
    directory.files
  end

  def site_files
    Site.where.not(stylesheet_filename: nil).find_each.map do |site|
      site.stylesheet.path
    end
  end

  def image_files
    Image.find_each.map do |image|
      [image.file.path] + image.file.versions.map do |_version_name, version|
        version.path
      end
    end
  end

  def valid_files
    (site_files + image_files).flatten
  end

  def clean_files
    missing_files = valid_files

    all_files.each do |file|
      next if missing_files.delete file.key

      file.destroy
      error("Deleted the following file: #{file.key}")
    end

    missing_files
  end
end
