class AddMainMenuPositionToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :main_menu_position, :integer

    add_index :pages, %i(site_id main_menu_position), unique: true
  end
end
