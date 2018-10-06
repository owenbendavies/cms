module Types
  class MessageType < Types::BaseObject
    implements GraphQL::Relay::Node.interface

    global_id_field :id

    field :name, String, null: false
    field :email, String, null: false
    field :phone, String, null: true
    field :message, String, null: false
    field :privacy_policy_agreed, Boolean, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def self.connection_type_class
      TotalCountConnection
    end
  end
end
