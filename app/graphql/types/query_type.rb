module Types
  class QueryType < Types::BaseObject
    include Pundit

    alias pundit_user context

    field :messages, [MessageType], null: true

    def messages
      policy_scope(Message).ordered
    end
  end
end
