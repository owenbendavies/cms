class AddDeviseRecoverableToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |table|
      table.string :reset_password_token, index: :unique
      table.datetime :reset_password_sent_at
    end
  end
end
