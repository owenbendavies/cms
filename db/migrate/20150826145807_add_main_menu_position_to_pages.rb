class AddMainMenuPositionToPages < ActiveRecord::Migration
  def change
    change_table :pages do |table|
      table.integer :main_menu_position

      table.index [:site_id, :main_menu_position], unique: true
    end
  end
end
