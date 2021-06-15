require 'rails_helper'

RSpec.describe DeleteOldVersionsJob do
  let(:recent_time) { 29.days.ago }
  let(:old_time) { 31.days.ago }

  let(:old_model) do
    Timecop.travel(old_time) do
      FactoryBot.create(:site)
    end
  end

  let(:old_page) do
    Timecop.travel(old_time) do
      FactoryBot.create(:page)
    end
  end

  let(:recent_model) do
    Timecop.travel(recent_time) do
      FactoryBot.create(:site)
    end
  end

  it 'deletes old versions' do
    expect { described_class.perform_now }
      .to change { old_model.versions.count }
      .by(-1)
  end

  it 'keeps old page versions' do
    expect { described_class.perform_now }
      .not_to(change { old_page.versions.count })
  end

  it 'keeps recent versions' do
    expect { described_class.perform_now }
      .not_to(change { recent_model.versions.count })
  end
end
