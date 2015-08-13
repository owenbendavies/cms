class AddDeviseInvitableToUsers < ActiveRecord::Migration
  def change
    change_table :users do |table|
      table.string :invitation_token
      table.datetime :invitation_created_at
      table.datetime :invitation_sent_at
      table.datetime :invitation_accepted_at
      table.belongs_to :invited_by, references: :users

      table.index :invitation_token, unique: true
    end

    change_column_null :users, :encrypted_password, true
  end
end
