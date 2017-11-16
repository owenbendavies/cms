require 'rails_helper'

RSpec.describe SystemPolicy do
  permissions :error_500?, :error_delayed?, :error_timeout? do
    let(:scope) { :system }

    context 'without user' do
      let(:user) { nil }

      it 'is not permitted' do
        expect(policy).not_to permit(context, scope)
      end
    end

    context 'with non sysadmin user' do
      let(:user) { FactoryBot.create(:user) }

      it 'is not permitted' do
        expect(policy).not_to permit(context, scope)
      end
    end

    context 'with sysadmin user' do
      let(:user) { FactoryBot.create(:user, :sysadmin) }

      it 'is permitted' do
        expect(policy).to permit(context, scope)
      end
    end
  end
end
