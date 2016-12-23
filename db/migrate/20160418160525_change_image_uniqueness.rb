class ChangeImageUniqueness < ActiveRecord::Migration[5.0]
  def change
    change_table :images do |table|
      table.index [:filename], unique: true
    end

    remove_index :images, column: [:site_id, :filename], unique: true
  end
end
