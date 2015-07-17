class AddNameToUsers < ActiveRecord::Migration
  def change
    change_table :users do |table|
      table.string :name, limit: 64
    end
  end
end
