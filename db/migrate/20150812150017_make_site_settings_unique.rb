class MakeSiteSettingsUnique < ActiveRecord::Migration[5.0]
  def change
    add_index :site_settings, [:user_id, :site_id], unique: true
  end
end
