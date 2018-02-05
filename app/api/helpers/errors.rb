module Helpers
  module Errors
    def forbidden
      message = {
        'http_status_code' => 403,
        'error' => 'Forbidden',
        'message' => 'Either you do not have permission or the resource was not found'
      }

      error!(message, message.fetch('http_status_code'))
    end

    def page_not_found
      message = {
        'http_status_code' => 404,
        'error' => 'Not found',
        'message' => 'Please check API documentation'
      }

      error!(message, message.fetch('http_status_code'))
    end

    def validation_errors(error)
      message = {
        'http_status_code' => 400,
        'error' => 'Bad Request',
        'messages' => error.full_messages
      }

      error!(message, message.fetch('http_status_code'))
    end
  end
end
