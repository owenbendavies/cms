class AddUidToPages < ActiveRecord::Migration[5.2]
  CHARSET = Array('a'..'z') + Array(0..9)

  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end

  class Page < ApplicationRecord
  end

  def up
    change_table :pages do |table|
      table.string :uid
    end

    Page.find_each do |page|
      page.update!(uid: Array.new(8) { CHARSET.sample }.join)
    end

    change_column_null :pages, :uid, false
  end

  def down
    remove_column :pages, :uid
  end
end
