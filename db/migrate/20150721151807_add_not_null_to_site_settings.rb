class AddNotNullToSiteSettings < ActiveRecord::Migration
  def change
    change_column_null :site_settings, :created_by_id, false
    change_column_null :site_settings, :updated_by_id, false
    change_column_null :site_settings, :created_at, false
    change_column_null :site_settings, :updated_at, false
  end
end
