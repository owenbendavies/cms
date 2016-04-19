class AddUniqueIndexToSitesStylesheets < ActiveRecord::Migration
  def change
    change_table :sites do |table|
      table.index [:stylesheet_filename], unique: true
    end
  end
end
