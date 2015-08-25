class RemoveCreatedBy < ActiveRecord::Migration
  def up
    remove_column :sites, :created_by_id
    remove_column :sites, :updated_by_id
    remove_column :images, :created_by_id
    remove_column :images, :updated_by_id
    remove_column :pages, :created_by_id
    remove_column :pages, :updated_by_id
    remove_column :site_settings, :created_by_id
    remove_column :site_settings, :updated_by_id
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
