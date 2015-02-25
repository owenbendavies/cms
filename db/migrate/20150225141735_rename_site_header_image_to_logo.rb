class RenameSiteHeaderImageToLogo < ActiveRecord::Migration
  def change
    rename_column :sites, :header_image_filename, :logo_filename
  end
end
