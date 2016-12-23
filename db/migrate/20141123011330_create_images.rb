class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |table|
      table.belongs_to :site, null: false

      table.string :name, null: false, limit: 64
      table.string :filename, null: false, limit: 40

      table.timestamps

      table.index [:site_id, :name], unique: true
      table.index [:site_id, :filename], unique: true
    end
  end
end
