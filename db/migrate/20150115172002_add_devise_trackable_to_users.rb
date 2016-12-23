class AddDeviseTrackableToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |table|
      table.integer :sign_in_count, default: 0, null: false
      table.datetime :current_sign_in_at
      table.datetime :last_sign_in_at
      table.inet :current_sign_in_ip
      table.inet :last_sign_in_ip
    end
  end
end
