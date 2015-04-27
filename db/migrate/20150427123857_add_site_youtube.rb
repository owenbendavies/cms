class AddSiteYoutube < ActiveRecord::Migration
  def change
    change_table :sites do |table|
      table.string :youtube, limit: 32
    end
  end
end
