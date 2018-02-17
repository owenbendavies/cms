require 'rails_helper'

RSpec.describe SystemPolicy do
  permissions :health? do
    context 'without user or site' do
      let(:user) { nil }
      let(:site) { nil }

      it 'is permitted' do
        expect(described_class).to permit(context)
      end
    end
  end

  permissions :test_500_error?, :test_delayed_error?, :test_timeout_error? do
    include_examples 'no user policy'

    context 'with sysadmin user' do
      let(:user) { FactoryBot.create(:user, :sysadmin) }

      it 'is permitted' do
        expect(described_class).to permit(context)
      end
    end
  end
end
