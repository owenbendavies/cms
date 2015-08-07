class AddDeviseConfirmableToUsers < ActiveRecord::Migration
  def change
    change_table :users do |table|
      table.string :confirmation_token
      table.datetime :confirmed_at
      table.datetime :confirmation_sent_at
      table.string :unconfirmed_email

      table.index :confirmation_token, unique: true
    end

    execute('UPDATE users SET confirmed_at = NOW()')
  end
end
