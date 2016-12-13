class CreateSites < ActiveRecord::Migration[5.0]
  def change
    create_table :sites do |table|
      table.string :host, null: false, limit: 64, index: :unique
      table.string :name, null: false, limit: 64
      table.string :sub_title, limit: 64
      table.string :layout, default: 'one_column', limit: 32, null: false
      table.string :copyright, limit: 64
      table.string :google_analytics, limit: 32
      table.string :charity_number, limit: 32
      table.string :stylesheet_filename, limit: 40
      table.text :sidebar_html_content

      table.timestamps

      table.boolean :main_menu_in_footer, default: false, null: false
      table.boolean :separate_header, default: true, null: false
    end
  end
end
