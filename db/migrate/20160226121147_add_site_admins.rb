class AddSiteAdmins < ActiveRecord::Migration
  def change
    change_table :site_settings do |table|
      table.boolean :admin, default: false, null: false
    end
  end
end
