class AddDeviseRememberableToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |table|
      table.datetime :remember_created_at
    end
  end
end
