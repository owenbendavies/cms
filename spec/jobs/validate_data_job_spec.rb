require 'rails_helper'

RSpec.describe ValidateDataJob do
  context 'with no data' do
    it 'does not send any errors to Rollbar' do
      expect(Rollbar).not_to receive(:error)
      described_class.perform_now
    end
  end

  context 'with valid data' do
    before do
      FactoryBot.create(:user, :sysadmin)
      FactoryBot.create(:site)
    end

    it 'does not send any errors to Rollbar' do
      expect(Rollbar).not_to receive(:error)
      described_class.perform_now
    end

    context 'with invalid data' do
      let!(:page) do
        FactoryBot.create(:page).tap do |page|
          page.update_attribute(:url, 'login') # rubocop:disable Rails/SkipsModelValidations
        end
      end

      it 'sends error to Rollbar' do
        error = "ValidateDataJob Page##{page.id}: Url is reserved"
        expect(Rollbar).to receive(:error).with(error).and_call_original
        described_class.perform_now
      end
    end
  end
end
