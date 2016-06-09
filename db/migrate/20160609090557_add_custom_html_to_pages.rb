class AddCustomHtmlToPages < ActiveRecord::Migration
  def change
    change_table :pages do |table|
      table.text :custom_html
    end
  end
end
