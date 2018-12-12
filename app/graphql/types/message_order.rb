module Types
  class MessageOrder < BaseInputObject
    argument :direction, Direction, required: true
    argument :field, MessageOrderField, required: true
  end
end
