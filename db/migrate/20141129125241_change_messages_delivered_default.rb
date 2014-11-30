class ChangeMessagesDeliveredDefault < ActiveRecord::Migration
  def change
    change_column_default :messages, :delivered, false
  end
end
