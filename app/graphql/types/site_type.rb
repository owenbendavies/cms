module Types
  class SiteType < ModelType
    field :address, String, null: false
    field :host, String, null: false
    field :name, String, null: false
    field :google_analytics, String, null: true
    field :charity_number, String, null: true
    field :sidebar_html_content, String, null: true
    field :main_menu_in_footer, Boolean, null: false
    field :separate_header, Boolean, null: false
    field :email, String, null: false
  end
end
