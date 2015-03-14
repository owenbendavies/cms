class AddMessagesForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :messages, :sites
  end
end
