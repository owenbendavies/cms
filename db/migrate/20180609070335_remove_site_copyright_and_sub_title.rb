class RemoveSiteCopyrightAndSubTitle < ActiveRecord::Migration[5.2]
  def change
    remove_column :sites, :sub_title, :string, limit: 64 # rubocop:disable Rails/BulkChangeTable
    remove_column :sites, :copyright, :string, limit: 64
  end
end
