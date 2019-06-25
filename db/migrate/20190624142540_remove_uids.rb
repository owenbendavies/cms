class RemoveUids < ActiveRecord::Migration[5.2]
  def up
    remove_column :messages, :uid
    remove_column :pages, :uid
    remove_column :sites, :uid
  end
end
