class RemoveSiteMainMenuLocations < ActiveRecord::Migration
  def up
    remove_columns :sites, :main_menu_in_topbar, :main_menu_in_page
  end

  def down
    change_table :sites do |table|
      table.boolean :main_menu_in_topbar, default: false, null: false
      table.boolean :main_menu_in_page, default: true, null: false
    end
  end
end
