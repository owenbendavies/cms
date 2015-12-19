class ChangeFilenameLength < ActiveRecord::Migration
  def up
    change_column :sites, :stylesheet_filename, :string, limit: 40
    change_column :images, :filename, :string, limit: 40
  end

  def down
    change_column :sites, :stylesheet_filename, :string, limit: 36
    change_column :images, :filename, :string, limit: 36
  end
end
