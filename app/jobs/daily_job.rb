class DailyJob < ApplicationJob
  def perform
    CleanS3Job.perform_later
    DeleteOldModelsJob.perform_later
    ValidateDataJob.perform_later
  end
end
