module Types
  class MessageType < ModelType
    field :email, String, null: false
    field :message, String, null: false
    field :name, String, null: false
    field :phone, String, null: true
    field :privacy_policy_agreed, Boolean, null: false
  end
end
