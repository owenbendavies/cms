class MakeSiteSettingsUnique < ActiveRecord::Migration
  def change
    change_table :site_settings do |table|
      table.index [:user_id, :site_id], unique: true
    end
  end
end
