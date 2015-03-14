class AddPagesForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :pages, :sites
    add_foreign_key :pages, :users, column: :created_by_id
    add_foreign_key :pages, :users, column: :updated_by_id
  end
end
