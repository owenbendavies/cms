class ChangeImageUniqueness < ActiveRecord::Migration[5.0]
  def change
    add_index :images, :filename, unique: true
    remove_index :images, column: [:site_id, :filename], unique: true
  end
end
