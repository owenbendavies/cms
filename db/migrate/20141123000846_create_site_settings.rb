class CreateSiteSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :site_settings do |table|
      table.references :user, null: false
      table.references :site, null: false

      table.timestamps
    end
  end
end
