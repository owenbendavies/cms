class AddAccountsSites < ActiveRecord::Migration
  def change
    create_join_table :accounts, :sites
  end
end
