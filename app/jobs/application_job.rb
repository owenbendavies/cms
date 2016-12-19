class ApplicationJob < ActiveJob::Base
  protected

  def error(message)
    Rollbar.error("#{self.class} #{message}")
  end
end
