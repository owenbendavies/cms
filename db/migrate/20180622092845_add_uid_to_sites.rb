class AddUidToSites < ActiveRecord::Migration[5.2]
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end

  class Site < ApplicationRecord
    CHARSET = Array('a'..'z') + Array(0..9)

    def set_uid
      self.uid ||= Array.new(8) { CHARSET.sample }.join
    end
  end

  def up
    change_table :sites do |table|
      table.string :uid
    end

    Site.find_each do |site|
      site.set_uid
      site.save!
    end

    change_column_null :sites, :uid, false
  end

  def down
    remove_column :sites, :uid
  end
end
