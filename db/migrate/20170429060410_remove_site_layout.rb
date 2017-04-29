class RemoveSiteLayout < ActiveRecord::Migration[5.0]
  def change
    remove_column :sites, :layout, :string, default: 'one_column', limit: 32, null: false
  end
end
