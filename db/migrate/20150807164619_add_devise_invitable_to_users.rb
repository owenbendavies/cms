class AddDeviseInvitableToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :invitation_token, :string
    add_column :users, :invitation_created_at, :datetime
    add_column :users, :invitation_sent_at, :datetime
    add_column :users, :invitation_accepted_at, :datetime
    add_belongs_to :users, :invited_by, index: { name: 'fk__users_invited_by_id' }

    change_column_null :users, :encrypted_password, true

    add_index :users, :invitation_token, unique: true

    add_foreign_key :users, :users, column: :invited_by_id, name: 'fk_users_invited_by_id'
  end
end
