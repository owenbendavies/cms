class RemoveSnsNotifications < ActiveRecord::Migration[5.2]
  def up
    drop_table :sns_notifications
  end

  def down
    create_table :sns_notifications, id: :serial do |table|
      table.json :message, null: false
      table.timestamps
    end
  end
end
