require 'rails_helper'

RSpec.describe SitePolicy do
  permissions :scope do
    subject(:policy_scope) { Pundit.policy_scope(context, Site) }

    let!(:site2) { FactoryBot.create(:site) }

    context 'with site user' do
      let(:user) { FactoryBot.build(:user, site: site) }

      it 'returns users sites' do
        expect(policy_scope).to contain_exactly site
      end
    end

    context 'with admin user' do
      let(:user) { FactoryBot.build(:user, :admin) }

      it 'returns all sites' do
        expect(policy_scope).to contain_exactly(site, site2)
      end
    end
  end

  permissions :index? do
    context 'without user' do
      it 'is not permitted' do
        expect(described_class).not_to permit(context)
      end
    end

    context 'with user' do
      let(:user) { FactoryBot.build :user }

      it 'is permitted' do
        expect(described_class).to permit(context)
      end
    end
  end

  permissions :update? do
    let(:record) { site }

    include_examples 'policy for site user'
  end

  permissions :css? do
    let(:record) { site }

    include_examples 'policy for site admin'
  end
end
