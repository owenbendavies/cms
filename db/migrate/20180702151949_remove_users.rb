class RemoveUsers < ActiveRecord::Migration[5.2]
  def change
    drop_table :site_settings
    drop_table :users
  end
end
