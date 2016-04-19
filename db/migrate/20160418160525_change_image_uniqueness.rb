class ChangeImageUniqueness < ActiveRecord::Migration
  def change
    change_table :images do |table|
      table.index [:filename], unique: true
    end

    remove_index :images, column: [:site_id, :filename], unique: true
  end
end
