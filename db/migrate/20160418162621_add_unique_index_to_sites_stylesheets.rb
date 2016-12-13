class AddUniqueIndexToSitesStylesheets < ActiveRecord::Migration[5.0]
  def change
    change_table :sites do |table|
      table.index [:stylesheet_filename], unique: true
    end
  end
end
