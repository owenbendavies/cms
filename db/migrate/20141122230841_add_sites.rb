class AddSites < ActiveRecord::Migration
  def change
    create_table :sites do |table|
      table.string :host, null: false
      table.string :name, null: false, limit: 64
      table.string :sub_title, limit: 64
      table.string :layout, default: 'one_column'
      table.string :asset_host
      table.string :main_menu
      table.string :copyright, limit: 64
      table.string :google_analytics
      table.string :charity_number
      table.string :css_filename
      table.boolean :allow_search_engines, default: true
      table.string :header_image_filename
      table.text :sidebar_html_content

      table.belongs_to :created_by, null: false
      table.belongs_to :updated_by, null: false

      table.timestamps
    end

    add_index :sites, :host, unique: true
  end
end
