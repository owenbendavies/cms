module Mutations
  class UpdatePage < BaseMutation
    argument :page_id, ID, required: true, loads: Types::PageType

    argument :contact_form, Boolean, required: false
    argument :custom_html, String, required: false
    argument :html_content, String, required: false
    argument :name, String, required: false
    argument :private, Boolean, required: false

    field :errors, [Types::FieldErrors], null: true
    field :page, Types::PageType, null: true

    def resolve(arguments)
      page = arguments.delete :page

      if page.update arguments
        { errors: [], page: page }
      else
        { errors: model_errors(page), page: nil }
      end
    end
  end
end
