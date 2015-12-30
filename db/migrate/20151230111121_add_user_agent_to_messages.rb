class AddUserAgentToMessages < ActiveRecord::Migration
  def change
    change_table :messages do |table|
      table.text :user_agent
    end
  end
end
