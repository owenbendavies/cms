class AddPages < ActiveRecord::Migration
  def change
    create_table :pages do |table|
      table.belongs_to :site, null: false, index: true

      table.string :url, null: false, limit: 64
      table.string :name, null: false, limit: 64
      table.boolean :private, default: false
      table.boolean :contact_form, default: false
      table.text :html_content

      table.belongs_to :created_by, null: false
      table.belongs_to :updated_by, null: false

      table.timestamps null: false
    end

    add_index :pages, [:site_id, :url], unique: true
  end
end
