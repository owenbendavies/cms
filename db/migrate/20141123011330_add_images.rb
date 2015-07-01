class AddImages < ActiveRecord::Migration
  def change
    create_table :images do |table|
      table.belongs_to :site, null: false

      table.string :name, null: false, limit: 64
      table.string :filename, null: false, limit: 36

      table.belongs_to :created_by, null: false, references: :accounts
      table.belongs_to :updated_by, null: false, references: :accounts

      table.timestamps null: false
    end
  end
end
