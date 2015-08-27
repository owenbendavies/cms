class AddSites < ActiveRecord::Migration
  def change
    create_table :sites do |table|
      table.string :host, null: false, limit: 64
      table.string :name, null: false, limit: 64
      table.string :sub_title, limit: 64
      table.string :layout, default: 'one_column', limit: 32, null: false
      table.text :main_menu_page_ids
      table.string :copyright, limit: 64
      table.string :google_analytics, limit: 32
      table.string :charity_number, limit: 32
      table.string :stylesheet_filename, limit: 36
      table.text :sidebar_html_content

      table.timestamps null: false

      table.boolean :main_menu_in_footer, default: false, null: false
      table.boolean :separate_header, default: true, null: false

      table.index :host, unique: true
    end
  end
end
