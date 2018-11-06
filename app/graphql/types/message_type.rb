module Types
  class MessageType < ModelType
    field :name, String, null: false
    field :email, String, null: false
    field :phone, String, null: true
    field :message, String, null: false
    field :privacy_policy_agreed, Boolean, null: false
  end
end
