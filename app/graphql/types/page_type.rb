module Types
  class PageType < ModelType
    field :contact_form, Boolean, null: false
    field :custom_html, String, null: true
    field :hidden, Boolean, null: false
    field :html_content, String, null: true
    field :name, String, null: false
    field :private, Boolean, null: false
    field :url, String, null: false
  end
end
