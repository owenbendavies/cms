class CreateStylesheets < ActiveRecord::Migration[5.2]
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end

  class Stylesheet < ApplicationRecord
  end

  class Site < ApplicationRecord
    mount_uploader :stylesheet, StylesheetUploader, mount_on: :stylesheet_filename
  end

  def up
    create_table :stylesheets, id: :serial do |table|
      table.belongs_to(
        :site,
        type: :integer,
        index: { unique: true },
        foreign_key: { name: 'fk_stylesheets_site_id' },
        null: false
      )

      table.text :css, null: false

      table.timestamps
    end

    Site.where.not(stylesheet_filename: nil).find_each do |site|
      Stylesheet.create!(site_id: site.id, css: site.stylesheet.read)
    end
  end

  def down
    drop_table :stylesheets
  end
end
