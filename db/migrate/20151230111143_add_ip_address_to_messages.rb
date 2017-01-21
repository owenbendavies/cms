class AddIpAddressToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :ip_address, :string, limit: 45
  end
end
