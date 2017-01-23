class RemoveSiteSocialNetworks < ActiveRecord::Migration[5.0]
  def change
    remove_column :sites, :facebook, :string, limit: 64
    remove_column :sites, :twitter, :string, limit: 15
    remove_column :sites, :linkedin, :string, limit: 32
    remove_column :sites, :github, :string, limit: 32
    remove_column :sites, :youtube, :string, limit: 32
  end
end
