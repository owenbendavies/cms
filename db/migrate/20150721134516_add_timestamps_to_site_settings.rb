class AddTimestampsToSiteSettings < ActiveRecord::Migration
  def change
    change_table :site_settings do |table|
      table.belongs_to :created_by, null: true, references: :users
      table.belongs_to :updated_by, null: true, references: :users

      table.timestamps null: true
    end
  end
end
