require 'rails_helper'

RSpec.describe SitePolicy do
  describe 'Scope' do
    subject(:policy_scope) { described_class::Scope.new(context, Site).resolve }

    let(:user) { FactoryBot.create(:user, site: site) }

    before { FactoryBot.create(:site) }

    it 'returns users sites' do
      expect(policy_scope).to contain_exactly site
    end
  end

  permissions :index? do
    context 'without user' do
      it 'is not permitted' do
        expect(described_class).not_to permit(context)
      end
    end

    context 'with user' do
      let(:user) { FactoryBot.create :user }

      it 'is permitted' do
        expect(described_class).to permit(context)
      end
    end
  end

  permissions :update? do
    let(:record) { site }

    include_examples 'policy for site user'
  end
end
