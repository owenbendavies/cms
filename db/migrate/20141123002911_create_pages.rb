class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |table|
      table.belongs_to :site, null: false, foreign_key: { name: 'fk_pages_site_id' }, index: { name: 'fk__pages_site_id' }

      table.string :url, null: false, limit: 64
      table.string :name, null: false, limit: 64
      table.boolean :private, default: false, null: false
      table.boolean :contact_form, default: false, null: false
      table.text :html_content

      table.timestamps

      table.index %i[site_id url], unique: true
    end
  end
end
