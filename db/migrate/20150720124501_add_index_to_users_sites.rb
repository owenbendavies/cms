class AddIndexToUsersSites < ActiveRecord::Migration
  def change
    change_table :sites_users do |table|
      table.column :id, :primary_key
    end

    rename_table :sites_users, :site_settings
  end
end
