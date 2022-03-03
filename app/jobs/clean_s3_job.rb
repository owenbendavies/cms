class CleanS3Job < ApplicationJob
  def perform
    clean_files.each do |file|
      error('found missing file', missing_file: file)
    end
  end

  private

  def all_files
    connection = Fog::Storage.new(CarrierWave::Uploader::Base.fog_credentials)
    directory = connection.directories.get(CarrierWave::Uploader::Base.fog_directory)
    directory.files
  end

  def image_files
    Image.find_each.map do |image|
      versions =
        image.file.versions.map do |_version_name, version|
          version.path
        end

      [image.file.path] + versions
    end
  end

  def clean_files
    missing_files = image_files.flatten

    all_files.each do |file|
      next if missing_files.delete file.key

      file.destroy # rubocop:disable Rails/SaveBang
      error('deleted unknown file', deleted_file: file.key)
    end

    missing_files
  end
end
