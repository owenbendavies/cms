class AddUidIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :messages, :uid, unique: true
    add_index :users, :uid, unique: true
  end
end
