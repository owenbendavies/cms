class ChangeSiteFacebookLimit < ActiveRecord::Migration
  def change
    change_column :sites, :facebook, :string, limit: 64
  end
end
