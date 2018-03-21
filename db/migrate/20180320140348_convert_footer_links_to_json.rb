class ConvertFooterLinksToJson < ActiveRecord::Migration[5.0]
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end

  class Site < ApplicationRecord
  end

  class FooterLink < ApplicationRecord
    acts_as_list scope: :site
  end

  def up
    add_column :sites, :links, :jsonb, default: []

    Site.find_each do |site|
      links = site.footer_links.map do |footer_link|
        footer_link.as_json.slice('name', 'url', 'icon')
      end

      site.update!(links: links)
    end

    drop_table :footer_links
  end

  def down
    create_footer_links

    Site.find_each do |site|
      site.links.each do |link|
        site.footer_links.create!(link)
      end
    end

    remove_column :sites, :links
  end

  private

  def create_footer_links
    create_table :footer_links do |table|
      table.belongs_to :site, null: false
      table.integer :position, null: false
      table.string :name, null: false
      table.string :url, null: false
      table.string :icon

      table.timestamps

      table.index %i[site_id position], unique: true
    end
  end
end
