class AddAdminToUsers < ActiveRecord::Migration
  def change
    change_table :users do |table|
      table.boolean :admin, null: false, default: false
    end
  end
end
