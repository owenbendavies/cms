class AddMessages < ActiveRecord::Migration
  def change
    create_table :messages do |table|
      table.integer :site_id, null: false
      table.string :subject, null: false
      table.string :name, null: false, limit: 64
      table.string :email, null: false, limit: 64
      table.string :phone, limit: 32
      table.boolean :delivered
      table.text :message, limit: 2048

      table.timestamps
    end

    add_index :messages, :site_id
  end
end
