class AddAccountsSites < ActiveRecord::Migration
  def change
    create_join_table :accounts, :sites do |table|
      table.index :account_id
      table.index :site_id
    end
  end
end
