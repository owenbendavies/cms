class ChangeImageFilenameNil < ActiveRecord::Migration
  def up
    change_column :images, :filename, :string, null: true, limit: 36
  end

  def down
    change_column :images, :filename, :string, null: false, limit: 36
  end
end
