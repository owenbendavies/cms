require 'rails_helper'

RSpec.describe CleanVersionsJob do
  let(:old_time) { 31.days.ago }

  let(:old_model) do
    Timecop.travel(old_time) do
      FactoryBot.create(:user)
    end
  end

  let(:old_page) do
    Timecop.travel(old_time) do
      FactoryBot.create(:page)
    end
  end

  let(:recent_model) do
    Timecop.travel(29.days.ago) do
      FactoryBot.create(:user)
    end
  end

  it 'remoes old versions' do
    expect { described_class.perform_now }.to change { old_model.versions.count }.by(-1)
  end

  it 'does not remove old page versions' do
    expect { described_class.perform_now }.not_to(change { old_page.versions.count })
  end

  it 'does not remove recent versions' do
    expect { described_class.perform_now }.not_to(change { recent_model.versions.count })
  end

  it 'logs how many versions are deleted' do
    old_model
    expect(Rails.logger).to receive(:info).with('CleanVersionsJob deleted 1').and_call_original
    described_class.perform_now
  end
end
