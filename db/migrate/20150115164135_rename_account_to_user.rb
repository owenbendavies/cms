class RenameAccountToUser < ActiveRecord::Migration
  def change
    rename_table :accounts, :users
    rename_table :accounts_sites, :sites_users
    rename_column :sites_users, :account_id, :user_id
  end
end
