class BaseJob < ActiveJob::Base
  queue_as :default

  protected

  def error(message)
    Rollbar.error(message)
  end
end
