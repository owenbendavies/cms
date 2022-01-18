require 'rails_helper'

RSpec.describe PagePolicy do
  permissions :scope do
    subject(:policy_scope) { Pundit.policy_scope(context, Page) }

    let!(:site_page) { create(:page, site: site) }
    let!(:private_site_page) { create(:page, private: true, site: site) }

    before { build(:page) }

    context 'without user' do
      it 'returns non private site pages' do
        expect(policy_scope).to contain_exactly site_page
      end
    end

    context 'with site user' do
      let(:user) { build(:user, site: site) }

      it 'returns all site pages' do
        expect(policy_scope).to contain_exactly(site_page, private_site_page)
      end
    end
  end

  permissions :index? do
    context 'without user' do
      it 'is permitted' do
        expect(described_class).to permit(context)
      end
    end
  end

  permissions :show?, :contact_form? do
    context 'with private page' do
      let(:record) { build(:page, private: true, site: site) }

      include_examples 'policy for user record'
    end

    context 'with non private page' do
      let(:record) { build(:page, site: site) }

      context 'without user' do
        it 'is permitted' do
          expect(described_class).to permit(context, record)
        end
      end
    end
  end

  permissions :create?, :update? do
    let(:record) { build(:page, site: site) }

    include_examples 'policy for user record'
  end
end
