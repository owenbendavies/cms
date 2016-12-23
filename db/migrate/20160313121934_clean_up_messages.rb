class CleanUpMessages < ActiveRecord::Migration[5.0]
  def change
    remove_column :messages, :ip_address, :string, limit: 45
    remove_column :messages, :user_agent, :text
  end
end
