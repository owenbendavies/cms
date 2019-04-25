module Types
  class QueryType < BaseObject
    include Pundit

    alias pundit_user context

    add_field(GraphQL::Types::Relay::NodeField)

    field :messages, MessageType.connection_type, null: true do
      argument :order_by, MessageOrder, required: true
    end

    field :pages, PageType.connection_type, null: false

    field :sites, SiteType.connection_type, null: true

    def messages(order_by:)
      policy_scope(Message).order(order_by.field.downcase => order_by.direction)
    end

    def pages
      policy_scope(Page).order(:name)
    end

    def sites
      policy_scope(Site).order(:host)
    end
  end
end
