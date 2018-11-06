module Types
  class QueryType < BaseObject
    include Pundit

    alias pundit_user context

    field :messages, MessageType.connection_type, null: true do
      argument :order_by, MessageOrder, required: true
    end

    field :sites, SiteType.connection_type, null: true

    field :node, field: GraphQL::Relay::Node.field

    def messages(order_by:)
      policy_scope(Message).order(order_by.field.downcase => order_by.direction)
    end

    def sites
      policy_scope(Site).order(:host)
    end
  end
end
