class AddNameToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :name, :string, limit: 64
    change_column_null :users, :name, false
  end

  def down
    remove_column :users, :name
  end
end
