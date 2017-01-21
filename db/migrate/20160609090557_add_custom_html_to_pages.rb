class AddCustomHtmlToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :custom_html, :text
  end
end
