require 'rails_helper'

RSpec.describe SitePolicy do
  permissions :scope do
    subject(:policy_scope) { Pundit.policy_scope(context, Site) }

    let!(:site2) { create(:site) }

    context 'with site user' do
      let(:user) { build(:user, site: site) }

      it 'returns users sites' do
        expect(policy_scope).to contain_exactly site
      end
    end

    context 'with admin user' do
      let(:user) { build(:user, :admin) }

      it 'returns all sites' do
        expect(policy_scope).to contain_exactly(site, site2)
      end
    end
  end

  permissions :update? do
    let(:record) { site }

    include_examples 'policy for site user'
  end
end
