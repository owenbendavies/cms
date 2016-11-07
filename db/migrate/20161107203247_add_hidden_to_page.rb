class AddHiddenToPage < ActiveRecord::Migration
  def change
    change_table :pages do |table|
      table.boolean :hidden, default: false, null: false
    end
  end
end
