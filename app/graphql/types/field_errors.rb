module Types
  class FieldErrors < BaseObject
    field :field, String, null: false
    field :messages, [String], null: false
  end
end
