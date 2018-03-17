class AddUuidToUsers < ActiveRecord::Migration[5.0]
  class User < ApplicationRecord
  end

  def up
    add_column :users, :uuid, :string

    User.find_each do |user|
      user.update!(uuid: SecureRandom.uuid)
    end

    change_column_null :users, :uuid, false
  end

  def down
    remove_column :users, :uuid
  end
end
