module Types
  class SiteType < ModelType
    field :address, String, null: false
    field :charity_number, String, null: true
    field :css, String, null: true
    field :email, String, null: false
    field :google_analytics, String, null: true
    field :host, String, null: false
    field :main_menu_in_footer, Boolean, null: false
    field :name, String, null: false
    field :separate_header, Boolean, null: false
    field :sidebar_html_content, String, null: true
  end
end
