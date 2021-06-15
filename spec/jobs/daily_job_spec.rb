require 'rails_helper'

RSpec.describe DailyJob do
  it 'runs CleanS3Job' do
    expect { described_class.perform_now }
      .to have_enqueued_job(CleanS3Job)
  end

  it 'runs DeleteOldVersionsJob' do
    expect { described_class.perform_now }
      .to have_enqueued_job(DeleteOldVersionsJob)
  end

  it 'runs ValidateDataJob' do
    expect { described_class.perform_now }
      .to have_enqueued_job(ValidateDataJob)
  end
end
