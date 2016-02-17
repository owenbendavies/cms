class RenameUserAdminToSysadmin < ActiveRecord::Migration
  def change
    rename_column :users, :admin, :sysadmin
  end
end
