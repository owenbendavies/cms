class AddImages < ActiveRecord::Migration
  def change
    create_table :images do |table|
      table.integer :site_id, null: false
      table.string :name, null: false, limit: 64
      table.string :filename, null: false

      table.integer :created_by_id, null: false
      table.integer :updated_by_id, null: false

      table.timestamps
    end

    add_index :images, :site_id
  end
end
