class DailyJob < BaseJob
  def perform
    CleanS3Job.perform_later
    ValidateDataJob.perform_later
  end
end
