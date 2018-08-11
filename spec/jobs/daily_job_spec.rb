require 'rails_helper'

RSpec.describe DailyJob do
  it 'runs CleanS3Job' do
    expect { described_class.perform_now }.to have_enqueued_job(CleanS3Job)
  end

  it 'runs DeleteOldModelsJob' do
    expect { described_class.perform_now }.to have_enqueued_job(DeleteOldModelsJob)
  end

  it 'runs ValidateDataJob' do
    expect { described_class.perform_now }.to have_enqueued_job(ValidateDataJob)
  end
end
