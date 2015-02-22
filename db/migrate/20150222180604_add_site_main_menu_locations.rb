class AddSiteMainMenuLocations < ActiveRecord::Migration
  def change
    change_table :sites do |table|
      table.boolean :main_menu_in_topbar, default: false, null: false
      table.boolean :main_menu_in_page, default: true, null: false
      table.boolean :main_menu_in_footer, default: false, null: false
    end
  end
end
