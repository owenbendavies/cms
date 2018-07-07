require 'rails_helper'

RSpec.describe MessagePolicy do
  permissions :index? do
    include_examples 'policy for site user'
  end

  permissions :create? do
    let(:record) { FactoryBot.build(:message, site: site) }

    context 'without site' do
      let(:site) { nil }

      it 'is not permitted' do
        expect(described_class).not_to permit(context, record)
      end
    end

    context 'without user' do
      it 'is permitted' do
        expect(described_class).to permit(context, record)
      end
    end
  end

  permissions :show?, :destroy? do
    let(:record) { FactoryBot.build(:message, site: site) }

    include_examples 'policy for user record'
  end
end
