class DailyJob < ApplicationJob
  def perform
    CleanS3Job.perform_later
    CleanVersionsJob.perform_later
    ValidateDataJob.perform_later
  end
end
