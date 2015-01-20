class AddDeviseRememberableToUsers < ActiveRecord::Migration
  def change
    change_table :users do |table|
      table.datetime :remember_created_at
    end
  end
end
