class AddUserAgentToMessages < ActiveRecord::Migration[5.0]
  def change
    change_table :messages do |table|
      table.text :user_agent
    end
  end
end
