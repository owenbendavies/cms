class CreateVersions < ActiveRecord::Migration[5.0]
  def change
    create_table :versions do |table|
      table.string :item_type, null: false
      table.integer :item_id, null: false, foreign_key: false
      table.string :event, null: false
      table.string :whodunnit
      table.text :object
      table.datetime :created_at

      table.index %i(item_type item_id)
    end
  end
end
