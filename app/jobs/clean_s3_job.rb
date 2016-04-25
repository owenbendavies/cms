class CleanS3Job < ActiveJob::Base
  DELETED_ERROR_MESSAGE = 'The following S3 files where deleted'.freeze
  MISSING_ERROR_MESSAGE = 'The following S3 files where missing'.freeze

  queue_as :default

  def perform
    deleted_files, missing_files = cleaned_files

    SystemMailer.error(DELETED_ERROR_MESSAGE, deleted_files).deliver_later if deleted_files.any?

    SystemMailer.error(MISSING_ERROR_MESSAGE, missing_files).deliver_later if missing_files.any?
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

  def cleaned_files
    deleted_files = []
    missing_files = valid_files

    all_files.each do |file|
      next if missing_files.delete file.key

      deleted_files << file.key
      file.destroy
    end

    [deleted_files, missing_files]
  end
end
