module Helpers
  module Errors
    def system_error!(name, status, errors = {})
      message = {
        error: I18n.t("api.errors.#{name}.error"),
        message: I18n.t("api.errors.#{name}.message"),
        errors: errors,
        with: Entities::SystemError
      }

      error!(message, status)
    end

    def forbidden
      system_error!(:forbidden, 403)
    end

    def page_not_found
      system_error!(:page_not_found, 404)
    end

    def record_invalid(exception)
      errors = exception.record.errors.messages
      system_error!(:record_invalid, 422, errors)
    end

    def unexpected_error
      system_error!(:unexpected_error, 500)
    end

    def validation_errors(exception)
      errors = exception.as_json.each_with_object({}) do |error, hash|
        hash[error.fetch(:params).first] = error.fetch(:messages)
      end

      system_error!(:validation_errors, 400, errors)
    end
  end
end
