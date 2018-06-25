class AddSitesUidIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :sites, :uid, unique: true
  end
end
