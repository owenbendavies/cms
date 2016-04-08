class CleanS3Job < ActiveJob::Base
  ERROR_MESSAGE = 'The following S3 files where deleted'.freeze

  queue_as :default

  def perform
    errors = cleaned_files

    return unless errors.any?

    SystemMailer.error(ERROR_MESSAGE, errors).deliver_later
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
    bad_files = []
    good_files = valid_files

    all_files.each do |file|
      next if good_files.include? file.key

      bad_files << file.key
      file.destroy
    end

    bad_files
  end
end
