class AddSiteSeparateHeader < ActiveRecord::Migration
  def change
    change_table :sites do |table|
      table.boolean :separate_header, default: true, null: false
    end
  end
end
