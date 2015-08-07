class AddNameToUsers < ActiveRecord::Migration
  def change
    change_table :users do |table|
      table.string :name, limit: 64, null: false
    end
  end
end
