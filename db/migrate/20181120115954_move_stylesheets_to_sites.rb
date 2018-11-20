class MoveStylesheetsToSites < ActiveRecord::Migration[5.2]
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end

  class Site < ApplicationRecord
    has_one :stylesheet
  end

  class Stylesheet < ApplicationRecord
    belongs_to :site
  end

  def up
    add_column :sites, :css, :text

    Stylesheet.find_each do |stylesheet|
      stylesheet.site.update!(css: stylesheet.css)
    end

    drop_table :stylesheets
  end

  def down
    add_stylesheets_table

    Site.where.not(css: nil).find_each do |site|
      site.create_stylesheet!(css: site.css)
    end

    remove_column :sites, :css
  end

  private

  def add_stylesheets_table
    create_table :stylesheets, id: :serial do |t|
      t.integer :site_id, null: false
      t.text :css, null: false
      t.timestamps

      t.index :site_id, unique: true
      t.foreign_key :sites, name: 'fk_stylesheets_site_id'
    end
  end
end
