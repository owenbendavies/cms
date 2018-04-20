class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |table|
      table.string :email, null: false, limit: 64
      table.string :encrypted_password, null: false, limit: 64

      table.timestamps

      table.index :email, unique: true
    end
  end
end
