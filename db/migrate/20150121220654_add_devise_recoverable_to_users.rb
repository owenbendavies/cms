class AddDeviseRecoverableToUsers < ActiveRecord::Migration
  def change
    change_table :users do |table|
      table.string :reset_password_token
      table.datetime :reset_password_sent_at
    end

    add_index :users, :reset_password_token, unique: true
  end
end
