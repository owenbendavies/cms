class AddSocialNetworksToSites < ActiveRecord::Migration
  def change
    change_table :sites do |table|
      table.string :facebook, limit: 64
      table.string :twitter, limit: 15
      table.string :linkedin, limit: 32
      table.string :github, limit: 32
      table.string :youtube, limit: 32
    end
  end
end
