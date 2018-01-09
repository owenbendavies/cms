module Helpers
  module Errors
    def forbidden
      message = {
        'http_status_code' => 403,
        'error' => 'Forbidden',
        'message' => 'Either you do not have permission or the resource was not found'
      }

      error!(message, 403)
    end

    def page_not_found
      message = {
        'http_status_code' => 404,
        'error' => 'Not found',
        'message' => 'Please check API documentation'
      }

      error!(message, 404)
    end
  end
end
