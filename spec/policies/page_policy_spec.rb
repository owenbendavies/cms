require 'rails_helper'

RSpec.describe PagePolicy do
  describe 'Scope' do
    subject(:policy_scope) { described_class::Scope.new(context, Page).resolve }

    let!(:site_page) { FactoryBot.create(:page, site: site) }
    let!(:private_site_page) { FactoryBot.create(:page, private: true, site: site) }

    before { FactoryBot.create(:page) }

    context 'without user' do
      it 'returns visible site pages' do
        expect(policy_scope).to contain_exactly site_page
      end
    end

    context 'with another site user' do
      let(:user) { FactoryBot.create :user }

      it 'returns visible site pages' do
        expect(policy_scope).to contain_exactly site_page
      end
    end

    context 'with site user' do
      let(:user) { FactoryBot.create(:user, site: site) }

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
      let(:record) { FactoryBot.create(:page, private: true, site: site) }

      include_examples 'policy for user record'
    end

    context 'with non private page' do
      let(:record) { FactoryBot.create(:page, site: site) }

      context 'without user' do
        it 'is permitted' do
          expect(described_class).to permit(context, record)
        end
      end

      context 'with another site' do
        let(:other_site) { FactoryBot.create(:site) }
        let(:record) { FactoryBot.create(:page, site: other_site) }

        it 'is not permitted' do
          expect(described_class).not_to permit(context, record)
        end
      end
    end
  end

  permissions :create?, :update?, :destroy? do
    let(:record) { FactoryBot.create(:page, site: site) }

    include_examples 'policy for user record'
  end
end
