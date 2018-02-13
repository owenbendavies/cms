module Helpers
  module Errors
    def t(key, options = {})
      key = ['api', 'errors', key].join('.') if key.first == '.'

      I18n.translate(key, options)
    end

    def forbidden
      message = {
        'error' => t('.forbidden.error'),
        'message' => t('.forbidden.message')
      }

      error!(message, 403)
    end

    def page_not_found
      message = {
        'error' => t('.page_not_found.error'),
        'message' => t('.page_not_found.message')
      }

      error!(message, 404)
    end

    def record_invalid(exception)
      message = {
        'error' => t('.record_invalid.error'),
        'message' => t('.record_invalid.message'),
        'errors' => exception.record.errors.messages
      }

      error!(message, 422)
    end

    def validation_errors(exception)
      errors = exception.as_json.each_with_object({}) do |error, hash|
        hash[error.fetch(:params).first] = error.fetch(:messages)
      end

      message = {
        'error' => t('.validation_errors.error'),
        'message' => t('.validation_errors.message'),
        'errors' => errors
      }

      error!(message, 400)
    end
  end
end
