class AddDeviseInvitableToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |table|
      table.string :invitation_token, index: :unique
      table.datetime :invitation_created_at
      table.datetime :invitation_sent_at
      table.datetime :invitation_accepted_at
      table.belongs_to :invited_by, references: :users
    end

    change_column_null :users, :encrypted_password, true
  end
end
