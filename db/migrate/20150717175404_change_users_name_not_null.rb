class ChangeUsersNameNotNull < ActiveRecord::Migration
  def change
    change_column_null :users, :name, false
  end
end
