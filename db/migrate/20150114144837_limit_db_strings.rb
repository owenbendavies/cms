class LimitDbStrings < ActiveRecord::Migration
  def up
    change_column :messages, :subject, :string, limit: 64
    change_column :sites, :layout, :string, limit: 32
    change_column :sites, :main_menu_page_ids, :text
    change_column :sites, :google_analytics, :string, limit: 32
    change_column :sites, :charity_number, :string, limit: 32
  end

  def down
    change_column :messages, :subject, :string
    change_column :sites, :layout, :string
    change_column :sites, :main_menu_page_ids, :string
    change_column :sites, :google_analytics, :string
    change_column :sites, :charity_number, :string
  end
end
