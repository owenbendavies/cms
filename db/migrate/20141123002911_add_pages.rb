class AddPages < ActiveRecord::Migration
  def change
    create_table :pages do |table|
      table.integer :site_id, null: false
      table.string :url, null: false, limit: 64
      table.string :name, null: false, limit: 64
      table.boolean :private, default: false
      table.boolean :contact_form, default: false
      table.text :html_content

      table.integer :created_by_id, null: false
      table.integer :updated_by_id, null: false

      table.timestamps
    end

    add_index :pages, :site_id
    add_index :pages, [:site_id, :url], unique: true
  end
end
