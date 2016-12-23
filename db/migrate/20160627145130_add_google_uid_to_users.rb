class AddGoogleUidToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |table|
      table.string :google_uid
    end
  end
end
