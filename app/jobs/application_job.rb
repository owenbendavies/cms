class ApplicationJob < ActiveJob::Base
  include Rollbar::ActiveJob

  protected

  def error(message, extra = {})
    full_message = [self.class.name, message].join(' ')
    full_extra = extra.merge(job: self.class.to_s)

    Rollbar.error(full_message, full_extra)
  end
end
