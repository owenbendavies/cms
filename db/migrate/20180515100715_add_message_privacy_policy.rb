class AddMessagePrivacyPolicy < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :privacy_policy_agreed, :boolean, default: false
  end
end
