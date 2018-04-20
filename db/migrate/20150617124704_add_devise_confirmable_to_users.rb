class AddDeviseConfirmableToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    execute('UPDATE users SET confirmed_at = NOW()')

    add_index :users, :confirmation_token, unique: true
  end

  def down
    remove_index :users, :confirmation_token
    remove_column :users, :confirmation_token
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_sent_at
    remove_column :users, :unconfirmed_email
  end
end
