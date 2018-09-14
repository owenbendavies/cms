module Types
  class QueryType < Types::BaseObject
    include Pundit

    alias pundit_user context

    field :messages, MessageType.connection_type, null: true

    def messages
      policy_scope(Message).ordered
    end
  end
end
