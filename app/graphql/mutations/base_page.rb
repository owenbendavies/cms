module Mutations
  class BasePage < BaseMutation
    argument :contact_form, Boolean, required: false
    argument :custom_html, String, required: false
    argument :html_content, String, required: false
    argument :name, String, required: false
    argument :private, Boolean, required: false

    field :errors, [Types::FieldErrors], null: true
    field :page, Types::PageType, null: true
  end
end
