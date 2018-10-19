module Types
  class MessageOrder < BaseInputObject
    argument :field, MessageOrderField, required: true
    argument :direction, Direction, required: true
  end
end
