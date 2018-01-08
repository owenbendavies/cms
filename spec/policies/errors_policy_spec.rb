require 'rails_helper'

RSpec.describe ErrorsPolicy do
  permissions :error_500?, :error_delayed?, :error_timeout? do
    include_examples 'no user policy'

    context 'with sysadmin user' do
      let(:user) { FactoryBot.create(:user, :sysadmin) }

      it 'is permitted' do
        expect(described_class).to permit(context)
      end
    end
  end
end
