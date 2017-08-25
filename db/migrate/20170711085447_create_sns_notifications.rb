class CreateSnsNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :sns_notifications do |table|
      table.json :message, null: false

      table.timestamps
    end
  end
end
