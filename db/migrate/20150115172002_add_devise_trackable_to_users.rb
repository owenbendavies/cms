class AddDeviseTrackableToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :password_digest, :encrypted_password

    change_table :users do |table|
      table.integer :sign_in_count, default: 0, null: false
      table.datetime :current_sign_in_at
      table.datetime :last_sign_in_at
      table.inet :current_sign_in_ip
      table.inet :last_sign_in_ip
    end
  end
end
