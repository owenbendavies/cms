class AddAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |table|
      table.string :email, null: false, limit: 64
      table.string :password_digest, null: false, limit: 64

      table.timestamps
    end

    add_index :accounts, :email, unique: true
  end
end
