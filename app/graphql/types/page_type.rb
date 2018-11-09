module Types
  class PageType < ModelType
    field :url, String, null: false
    field :name, String, null: false
    field :private, Boolean, null: false
    field :contact_form, Boolean, null: false
    field :html_content, String, null: true
    field :custom_html, String, null: true
    field :hidden, Boolean, null: false
  end
end
