class AddIpAddressToMessages < ActiveRecord::Migration
  def change
    change_table :messages do |table|
      table.string :ip_address, limit: 45
    end
  end
end
