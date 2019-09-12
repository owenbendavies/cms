module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    def model_errors(model)
      model.errors.messages.map do |field, messages|
        {
          'field' => field.to_s.camelize(:lower),
          'messages' => messages
        }
      end
    end
  end
end
