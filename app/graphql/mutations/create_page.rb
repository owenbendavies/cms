module Mutations
  class CreatePage < BasePage
    argument :name, String, required: true

    def resolve(arguments)
      page = context[:site].pages.new
      update_model(page, arguments)
    end
  end
end
