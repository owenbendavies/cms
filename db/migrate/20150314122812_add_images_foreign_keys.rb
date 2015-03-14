class AddImagesForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :images, :sites
    add_foreign_key :images, :users, column: :created_by_id
    add_foreign_key :images, :users, column: :updated_by_id
  end
end
