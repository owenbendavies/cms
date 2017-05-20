require 'rails_helper'

RSpec.describe CleanVersionsJob do
  let(:query_limit) { 2 }

  let!(:old_model) do
    Timecop.travel(31.days.ago) do
      FactoryGirl.create(:user)
    end
  end

  let!(:recent_model) do
    Timecop.travel(29.days.ago) do
      FactoryGirl.create(:user)
    end
  end

  it 'remoes old versions' do
    expect { run_job }.to change { old_model.versions.count }.by(-1)
  end

  it 'does not remove recent versions' do
    expect { run_job }.not_to(change { recent_model.versions.count })
  end

  it 'logs how many versions are deleted' do
    expect(Rails.logger).to receive(:info).with('CleanVersionsJob deleted 1').and_call_original
    run_job
  end
end
