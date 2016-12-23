class AddHiddenToPage < ActiveRecord::Migration[5.0]
  def change
    change_table :pages do |table|
      table.boolean :hidden, default: false, null: false
    end
  end
end
