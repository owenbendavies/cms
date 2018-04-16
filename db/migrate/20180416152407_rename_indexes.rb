class RenameIndexes < ActiveRecord::Migration[5.0]
  def change
    rename_index :site_settings, 'fk__site_settings_user_id', 'index_site_settings_on_user_id'
    rename_index :site_settings, 'fk__site_settings_site_id', 'index_site_settings_on_site_id'
    rename_index :pages, 'fk__pages_site_id', 'index_pages_on_site_id'
    rename_index :messages, 'fk__messages_site_id', 'index_messages_on_site_id'
    rename_index :images, 'fk__images_site_id', 'index_images_on_site_id'
    rename_index :users, 'fk__users_invited_by_id', 'index_users_on_invited_by_id'
  end
end
