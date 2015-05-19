class RemoveSitesLogo < ActiveRecord::Migration
  def change
    remove_column :sites, :logo_filename, :string, limit: 36
  end
end
