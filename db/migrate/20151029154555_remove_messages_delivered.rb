class RemoveMessagesDelivered < ActiveRecord::Migration
  def up
    remove_column :messages, :delivered
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
