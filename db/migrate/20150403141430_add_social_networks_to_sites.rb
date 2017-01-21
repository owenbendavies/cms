class AddSocialNetworksToSites < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :facebook, :string, limit: 64
    add_column :sites, :twitter, :string, limit: 15
    add_column :sites, :linkedin, :string, limit: 32
    add_column :sites, :github, :string, limit: 32
    add_column :sites, :youtube, :string, limit: 32
  end
end
