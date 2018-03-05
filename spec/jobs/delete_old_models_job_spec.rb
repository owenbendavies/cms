require 'rails_helper'

RSpec.describe DeleteOldModelsJob do
  let(:recent_time) { 29.days.ago }
  let(:old_time) { 31.days.ago }

  before do
    allow(Rails.logger).to receive(:info).and_call_original
  end

  context 'with messages' do
    let!(:old_message) do
      Timecop.travel(old_time) do
        FactoryBot.create(:message)
      end
    end

    let!(:recent_message) do
      Timecop.travel(recent_time) do
        FactoryBot.create(:message)
      end
    end

    it 'deletes old messages' do
      described_class.perform_now
      expect(Message.where(id: old_message.id)).not_to exist
    end

    it 'keeps recent messages' do
      described_class.perform_now
      expect(Message.where(id: recent_message.id)).to exist
    end

    it 'logs how many messages are deleted' do
      message = 'DeleteOldModelsJob deleted 1 messages'
      expect(Rails.logger).to receive(:info).with(message).and_call_original
      described_class.perform_now
    end
  end

  context 'with versions' do
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
      Timecop.travel(recent_time) do
        FactoryBot.create(:user)
      end
    end

    it 'deletes old versions' do
      expect { described_class.perform_now }.to change { old_model.versions.count }.by(-1)
    end

    it 'keeps old page versions' do
      expect { described_class.perform_now }.not_to(change { old_page.versions.count })
    end

    it 'keeps recent versions' do
      expect { described_class.perform_now }.not_to(change { recent_model.versions.count })
    end

    it 'logs how many versions are deleted' do
      old_model
      message = 'DeleteOldModelsJob deleted 1 versions'
      expect(Rails.logger).to receive(:info).with(message).and_call_original
      described_class.perform_now
    end
  end
end
