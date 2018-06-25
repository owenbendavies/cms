class RemoveSitesStylesheetFilename < ActiveRecord::Migration[5.2]
  def up
    remove_column :sites, :stylesheet_filename
  end

  def down
    change_table :sites do |t|
      t.string :stylesheet_filename, limit: 40
      t.index :stylesheet_filename, unique: true
    end
  end
end
