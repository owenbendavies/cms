class AddUserAgentToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :user_agent, :text
  end
end
