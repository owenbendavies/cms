class RemoveSitesAssetHost < ActiveRecord::Migration
  def change
    remove_column :sites, :asset_host, :string
  end
end
