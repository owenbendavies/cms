module Mutations
  class DeletePages < BaseMutation
    argument :page_ids, [ID], required: true, loads: Types::PageType

    field :pages, [Types::PageType], null: true

    def resolve(pages:)
      pages.each(&:destroy!)

      {
        pages:
      }
    end
  end
end
