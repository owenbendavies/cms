class AddGoogleUidToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :google_uid, :string
  end
end
