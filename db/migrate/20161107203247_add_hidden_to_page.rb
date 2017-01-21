class AddHiddenToPage < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :hidden, :boolean, default: false, null: false
  end
end
