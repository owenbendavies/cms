class RemovePagesHidden < ActiveRecord::Migration[5.2]
  def change
    remove_column :pages, :hidden, :boolean, default: false, null: false
  end
end
