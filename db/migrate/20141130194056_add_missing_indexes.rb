class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :images, :created_by_id
    add_index :images, :updated_by_id
    add_index :pages, :created_by_id
    add_index :pages, :updated_by_id
    add_index :sites, :created_by_id
    add_index :sites, :updated_by_id
  end
end
