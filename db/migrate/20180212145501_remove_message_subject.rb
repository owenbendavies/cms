class RemoveMessageSubject < ActiveRecord::Migration[5.0]
  def up
    remove_column :messages, :subject
  end
end
