module Mutations
  class UpdatePage < BasePage
    argument :page_id, ID, required: true, loads: Types::PageType
    argument :name, String, required: false

    def resolve(arguments)
      page = arguments.delete :page
      update_model(page, arguments)
    end
  end
end
