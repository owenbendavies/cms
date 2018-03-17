class AddUuidToMessages < ActiveRecord::Migration[5.0]
  class Message < ApplicationRecord
  end

  def up
    add_column :messages, :uuid, :string

    Message.find_each do |message|
      message.update!(uuid: SecureRandom.uuid)
    end

    change_column_null :messages, :uuid, false
  end

  def down
    remove_column :messages, :uuid
  end
end
