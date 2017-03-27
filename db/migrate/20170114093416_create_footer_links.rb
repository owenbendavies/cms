class CreateFooterLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :footer_links do |table|
      table.belongs_to :site, null: false
      table.integer :position, null: false
      table.string :name, null: false
      table.string :url, null: false
      table.string :icon

      table.timestamps

      table.index %i(site_id position), unique: true
    end
  end
end
