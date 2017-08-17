module Helpers
  module Errors
    def page_not_found
      error!('404 not found', 404)
    end
  end
end
