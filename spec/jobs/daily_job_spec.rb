require 'rails_helper'

RSpec.describe DailyJob do
  it 'runs all daily jobs' do
    expect(CleanS3Job).to receive(:perform_later).once.and_call_original
    expect(CleanVersionsJob).to receive(:perform_later).once.and_call_original
    expect(ValidateDataJob).to receive(:perform_later).once.and_call_original

    expect { described_class.perform_now }.to change(Delayed::Job, :count).from(0).to(3)

    Delayed::Worker.new.work_off
  end
end
