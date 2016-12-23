class AddCustomHtmlToPages < ActiveRecord::Migration[5.0]
  def change
    change_table :pages do |table|
      table.text :custom_html
    end
  end
end
