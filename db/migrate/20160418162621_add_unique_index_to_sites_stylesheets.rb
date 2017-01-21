class AddUniqueIndexToSitesStylesheets < ActiveRecord::Migration[5.0]
  def change
    add_index :sites, :stylesheet_filename, unique: true
  end
end
