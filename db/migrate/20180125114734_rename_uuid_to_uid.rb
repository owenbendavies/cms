class RenameUuidToUid < ActiveRecord::Migration[5.0]
  def change
    rename_column :messages, :uuid, :uid
    rename_column :users, :uuid, :uid
  end
end
