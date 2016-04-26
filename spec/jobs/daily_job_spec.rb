require 'rails_helper'

RSpec.describe DailyJob do
  it 'runs all daily jobs' do
    expect(CleanS3Job).to receive(:perform_later).once.and_call_original
    expect(ValidateDataJob).to receive(:perform_later).once.and_call_original

    expect(Delayed::Job.count).to eq 0

    described_class.perform_now

    expect(Delayed::Job.count).to eq 2

    Delayed::Worker.new.work_off
  end
end
