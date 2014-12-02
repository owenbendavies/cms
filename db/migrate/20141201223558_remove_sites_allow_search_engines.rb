class RemoveSitesAllowSearchEngines < ActiveRecord::Migration
  def change
    remove_column :sites, :allow_search_engines, :boolean, default: true, null: false
  end
end
