class BaseJob < ActiveJob::Base
  queue_as :default

  protected

  def error(message, errors)
    SystemMailer.error(message, errors).deliver_later
  end
end
