class AddSitesForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :sites, :users, column: :created_by_id
    add_foreign_key :sites, :users, column: :updated_by_id

    add_foreign_key :sites_users, :users
    add_foreign_key :sites_users, :sites
  end
end
