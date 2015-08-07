class AddDeviseRecoverableToUsers < ActiveRecord::Migration
  def change
    change_table :users do |table|
      table.string :reset_password_token
      table.datetime :reset_password_sent_at

      table.index :reset_password_token, unique: true
    end
  end
end
