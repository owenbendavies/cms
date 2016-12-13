class RenameUserAdminToSysadmin < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :admin, :sysadmin
  end
end
