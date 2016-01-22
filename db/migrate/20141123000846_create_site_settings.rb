class CreateSiteSettings < ActiveRecord::Migration
  def change
    create_table :site_settings do |table|
      table.references :user, null: false
      table.references :site, null: false

      table.timestamps null: false
    end
  end
end
