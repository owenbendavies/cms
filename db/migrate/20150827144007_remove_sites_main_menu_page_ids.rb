class RemoveSitesMainMenuPageIds < ActiveRecord::Migration
  def up
    remove_column :sites, :main_menu_page_ids
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
