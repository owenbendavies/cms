module Types
  class MutationType < BaseObject
    field :delete_messages, mutation: Mutations::DeleteMessages
  end
end
