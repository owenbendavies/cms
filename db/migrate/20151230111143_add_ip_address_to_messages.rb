class AddIpAddressToMessages < ActiveRecord::Migration[5.0]
  def change
    change_table :messages do |table|
      table.string :ip_address, limit: 45
    end
  end
end
