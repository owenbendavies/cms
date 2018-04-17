class CreateSiteSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :site_settings do |table|
      table.belongs_to :user, null: false, foreign_key: { name: 'fk_site_settings_user_id' }, index: { name: 'fk__site_settings_user_id' }
      table.belongs_to :site, null: false, foreign_key: { name: 'fk_site_settings_site_id' }, index: { name: 'fk__site_settings_site_id' }

      table.timestamps
    end
  end
end
