class AddDeviseLockableToUsers < ActiveRecord::Migration
  def change
    change_table :users do |table|
      table.integer :failed_attempts, default: 0, null: false
      table.string :unlock_token
      table.datetime :locked_at
    end

    add_index :users, :unlock_token, unique: true
  end
end
