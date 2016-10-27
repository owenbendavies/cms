class ApplicationJob < ActiveJob::Base
  protected

  def error(message)
    Rollbar.error(message)
  end
end
