require 'rails_helper'

RSpec.describe ErrorsPolicy do
  permissions :error_500?, :error_delayed?, :error_timeout? do
    context 'without user' do
      it 'is not permitted' do
        expect(described_class).not_to permit(context)
      end
    end

    context 'with non sysadmin user' do
      let(:user) { FactoryBot.create(:user) }

      it 'is not permitted' do
        expect(described_class).not_to permit(context)
      end
    end

    context 'with sysadmin user' do
      let(:user) { FactoryBot.create(:user, :sysadmin) }

      it 'is permitted' do
        expect(described_class).to permit(context)
      end
    end
  end
end
