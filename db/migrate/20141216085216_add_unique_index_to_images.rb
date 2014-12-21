class AddUniqueIndexToImages < ActiveRecord::Migration
  def change
    add_index :images, [:site_id, :name], unique: true
    add_index :images, [:site_id, :filename], unique: true
  end
end
