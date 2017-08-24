require 'rails_helper'

RSpec.describe DailyJob do
  after { Delayed::Worker.new.work_off }

  it 'runs CleanS3Job' do
    expect(CleanS3Job).to receive(:perform_later).once.and_call_original
    described_class.perform_now
  end

  it 'runs CleanVersionsJob' do
    expect(CleanVersionsJob).to receive(:perform_later).once.and_call_original
    described_class.perform_now
  end

  it 'runs ValidateDataJob' do
    expect(ValidateDataJob).to receive(:perform_later).once.and_call_original
    described_class.perform_now
  end

  it 'runs jobs as jobs' do
    expect { described_class.perform_now }.to change(Delayed::Job, :count).from(0).to(3)
  end
end
