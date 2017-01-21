class AddSiteAdmins < ActiveRecord::Migration[5.0]
  def change
    add_column :site_settings, :admin, :boolean, default: false, null: false
  end
end
