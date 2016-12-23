class AddNameToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |table|
      table.string :name, limit: 64, null: false
    end
  end
end
