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

    def update_model(model, arguments)
      model_name = model.class.name.underscore

      if model.update arguments
        { :errors => [], model_name => model }
      else
        { :errors => model_errors(model), model_name => nil }
      end
    end
  end
end
