class AddMessages < ActiveRecord::Migration
  def change
    create_table :messages do |table|
      table.belongs_to :site, null: false, index: true

      table.string :subject, null: false
      table.string :name, null: false, limit: 64
      table.string :email, null: false, limit: 64
      table.string :phone, limit: 32
      table.boolean :delivered
      table.text :message, limit: 2048

      table.timestamps null: false
    end
  end
end
