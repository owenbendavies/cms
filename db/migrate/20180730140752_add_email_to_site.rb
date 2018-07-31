class AddEmailToSite < ActiveRecord::Migration[5.2]
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end

  class Site < ApplicationRecord
  end

  def up
    change_table :sites do |t|
      t.string :email
    end

    Site.find_each do |site|
      site.update! email: "noreply@#{site.host.gsub(/^www\./, '')}"
    end

    change_column_null :sites, :email, false
  end

  def down
    remove_column :sites, :email
  end
end
