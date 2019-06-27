require 'rails_helper'

RSpec.describe PagePolicy do
  describe 'Scope' do
    subject(:policy_scope) { described_class::Scope.new(context, Page).resolve }

    let!(:site_page) { FactoryBot.create(:page, site: site) }
    let!(:private_site_page) { FactoryBot.create(:page, private: true, site: site) }

    before { FactoryBot.build(:page) }

    context 'without user' do
      it 'returns non private site pages' do
        expect(policy_scope).to contain_exactly site_page
      end
    end

    context 'with site user' do
      let(:user) { FactoryBot.build(:user, site: site) }

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
      let(:record) { FactoryBot.build(:page, private: true, site: site) }

      include_examples 'policy for user record'
    end

    context 'with non private page' do
      let(:record) { FactoryBot.build(:page, site: site) }

      context 'without user' do
        it 'is permitted' do
          expect(described_class).to permit(context, record)
        end
      end
    end
  end

  permissions :create?, :update? do
    let(:record) { FactoryBot.build(:page, site: site) }

    include_examples 'policy for user record'
  end
end
