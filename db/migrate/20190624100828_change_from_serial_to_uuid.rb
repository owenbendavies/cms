class ChangeFromSerialToUuid < ActiveRecord::Migration[5.2]
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end

  class DelayedJob < ApplicationRecord
  end

  class Image < ApplicationRecord
    belongs_to :site
  end

  class Message < ApplicationRecord
    belongs_to :site
  end

  class Page < ApplicationRecord
    belongs_to :site
  end

  class Site < ApplicationRecord
    belongs_to :privacy_policy_page, class_name: 'Page', optional: true
  end

  class Version < ApplicationRecord
    belongs_to :item, polymorphic: true
  end

  TABLES = %w[
    delayed_jobs
    images
    messages
    pages
    sites
    versions
  ].freeze

  private_constant :TABLES

  def up
    enable_extension 'pgcrypto'
    add_uuids
    ids_to_uuids
    add_indexes
    make_uuids_primary_key
    add_forign_keys
  end

  private

  def add_uuids
    TABLES.each do |table|
      add_column table, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    end
  end

  def ids_to_uuids
    id_to_uuid(Image, 'site', null: false)
    id_to_uuid(Message, 'site', null: false)
    id_to_uuid(Page, 'site', null: false)
    id_to_uuid(Site, 'privacy_policy_page')
    id_to_uuid(Version, 'item', null: false)
  end

  def id_to_uuid(table_class, relation_name, null: true)
    table_class.connection.schema_cache.clear!
    table_class.reset_column_information

    foreign_key = "#{relation_name}_id"
    new_foreign_key = "#{relation_name}_uuid"

    add_column table_class.table_name, new_foreign_key, :uuid

    update_relations(table_class, relation_name, new_foreign_key)

    remove_column table_class.table_name, foreign_key
    rename_column table_class.table_name, new_foreign_key, foreign_key
    change_column_null table_class.table_name, foreign_key, null
  end

  def update_relations(table_class, relation_name, new_foreign_key)
    table_class.find_each do |record|
      relation = record.public_send(relation_name)
      record.update!(new_foreign_key => relation.uuid) if relation
    end
  end

  def add_indexes
    add_index :images, %w[site_id name], unique: true
    add_index :images, %w[site_id]
    add_index :messages, %w[site_id]
    add_index :pages, %w[site_id main_menu_position], unique: true
    add_index :pages, %w[site_id url], unique: true
    add_index :pages, %w[site_id]
    add_index :versions, %w[item_type item_id]
  end

  def make_uuids_primary_key
    TABLES.each do |table|
      remove_column table, :id
      rename_column table, :uuid, :id
      execute "ALTER TABLE #{table} ADD PRIMARY KEY (id);"
    end
  end

  def add_forign_keys
    add_foreign_key 'images', 'sites', name: 'fk_images_site_id'
    add_foreign_key 'messages', 'sites', name: 'fk_messages_site_id'
    add_foreign_key 'pages', 'sites', name: 'fk_pages_site_id'

    add_foreign_key(
      'sites',
      'pages',
      column: 'privacy_policy_page_id',
      name: 'fk__sites_privacy_policy_page_id'
    )
  end
end
