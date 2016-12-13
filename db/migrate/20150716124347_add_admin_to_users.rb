class AddAdminToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |table|
      table.boolean :admin, null: false, default: false
    end
  end
end
