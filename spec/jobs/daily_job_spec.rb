require 'rails_helper'

RSpec.describe DailyJob do
  let(:query_limit) { 9 }

  after { Delayed::Worker.new.work_off }

  it 'runs CleanS3Job' do
    expect(CleanS3Job).to receive(:perform_later).once.and_call_original
    run_job
  end

  it 'runs CleanVersionsJob' do
    expect(CleanVersionsJob).to receive(:perform_later).once.and_call_original
    run_job
  end

  it 'runs ValidateDataJob' do
    expect(ValidateDataJob).to receive(:perform_later).once.and_call_original
    run_job
  end

  it 'runs jobs as jobs' do
    expect { run_job }.to change(Delayed::Job, :count).from(0).to(3)
  end
end
