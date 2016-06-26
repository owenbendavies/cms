class AddGoogleUidToUsers < ActiveRecord::Migration
  def change
    change_table :users do |table|
      table.string :google_uid
    end
  end
end
