module Types
  class MutationType < BaseObject
    field :delete_messages, mutation: Mutations::DeleteMessages
    field :delete_pages, mutation: Mutations::DeletePages
  end
end
