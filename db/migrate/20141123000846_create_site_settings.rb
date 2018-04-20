class CreateSiteSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :site_settings do |table|
      table.belongs_to :user, null: false, index: { name: 'fk__site_settings_user_id' }
      table.belongs_to :site, null: false, index: { name: 'fk__site_settings_site_id' }

      table.timestamps

      table.foreign_key :users, name: 'fk_site_settings_user_id'
      table.foreign_key :sites, name: 'fk_site_settings_site_id'
    end
  end
end
