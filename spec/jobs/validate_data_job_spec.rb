require 'rails_helper'

RSpec.describe ValidateDataJob do
  context 'without data' do
    it 'does not send any errors to Rollbar' do
      expect(Rollbar).not_to receive(:error)
      described_class.perform_now
    end
  end

  context 'with valid data' do
    before do
      create(:site)
    end

    it 'does not send any errors to Rollbar' do
      expect(Rollbar).not_to receive(:error)
      described_class.perform_now
    end

    context 'with invalid data' do
      let!(:page) do
        create(:page).tap do |page|
          page.update_attribute(:url, 'login') # rubocop:disable Rails/SkipsModelValidations
        end
      end

      let(:extra) do
        {
          job: 'ValidateDataJob',
          model_class: 'Page',
          model_id: page.id,
          model_errors: ['Url is reserved']
        }
      end

      it 'sends error to Rollbar' do
        error = 'ValidateDataJob found invalid model'
        expect(Rollbar).to receive(:error).with(error, extra).and_call_original
        described_class.perform_now
      end
    end
  end
end
