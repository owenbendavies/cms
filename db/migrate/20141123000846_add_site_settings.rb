class AddSiteSettings < ActiveRecord::Migration
  def change
    create_table :site_settings, id: false  do |table|
      table.references :user, null: false
      table.references :site, null: false
    end

    change_table :site_settings do |table|
      table.column :id, :primary_key

      table.belongs_to :created_by, null: false, references: :users
      table.belongs_to :updated_by, null: false, references: :users

      table.timestamps null: false
    end
  end
end
