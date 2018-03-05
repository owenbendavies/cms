class AddIndexToMessagesCreatedAt < ActiveRecord::Migration[5.0]
  def change
    add_index :messages, :created_at
  end
end
