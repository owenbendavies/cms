module Mutations
  class DeleteMessages < BaseMutation
    argument :message_ids, [ID], required: true, loads: Types::MessageType

    field :messages, [Types::MessageType], null: true

    def resolve(messages:)
      messages.each(&:destroy!)

      {
        messages:
      }
    end
  end
end
