class AddNotNullConstraints < ActiveRecord::Migration
  def change
    change_column_null :sites, :layout, false
    change_column_null :images, :filename, false
  end
end
