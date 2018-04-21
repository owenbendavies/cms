class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |table|
      table.belongs_to :site, null: false, index: { name: 'fk__images_site_id' }

      table.string :name, null: false, limit: 64
      table.string :filename, null: false, limit: 40

      table.timestamps

      table.index %i[site_id name], unique: true
      table.index %i[site_id filename], unique: true

      table.foreign_key :sites, name: 'fk_images_site_id'
    end
  end
end
