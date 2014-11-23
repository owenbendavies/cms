class AddSites < ActiveRecord::Migration
  def change
    create_table :sites do |table|
      table.string :host, null: false, limit: 64
      table.string :name, null: false, limit: 64
      table.string :sub_title, limit: 64
      table.string :layout, default: 'one_column'
      table.string :asset_host
      table.string :main_menu_page_ids
      table.string :copyright, limit: 64
      table.string :google_analytics
      table.string :charity_number
      table.string :stylesheet_filename
      table.boolean :allow_search_engines, default: true
      table.string :header_image_filename
      table.text :sidebar_html_content

      table.belongs_to :created_by, null: false
      table.belongs_to :updated_by, null: false

      table.timestamps null: false
    end

    add_index :sites, :host, unique: true
  end
end
