class AddDeviseConfirmableToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |table|
      table.string :confirmation_token, index: :unique
      table.datetime :confirmed_at
      table.datetime :confirmation_sent_at
      table.string :unconfirmed_email
    end

    execute('UPDATE users SET confirmed_at = NOW()')
  end
end
