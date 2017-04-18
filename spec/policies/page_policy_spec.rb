require 'rails_helper'

RSpec.describe PagePolicy do
  describe 'Scope' do
    subject(:policy_scope) { described_class::Scope.new(context, scope).resolve }

    let(:scope) { Page }
    let!(:site_page) { FactoryGirl.create(:page, site: site) }
    let!(:private_site_page) { FactoryGirl.create(:page, :private, site: site) }

    before { FactoryGirl.create(:page) }

    context 'no user' do
      let(:user) { nil }

      it 'returns visible site pages' do
        expect(policy_scope).to contain_exactly site_page
      end
    end

    context 'another site user' do
      let(:user) { FactoryGirl.create :user }

      it 'returns visible site pages' do
        expect(policy_scope).to contain_exactly site_page
      end
    end

    context 'site user' do
      let(:user) { FactoryGirl.create(:user, site: site) }

      it 'returns all site pages' do
        expect(policy_scope).to contain_exactly(site_page, private_site_page)
      end
    end
  end

  permissions :index? do
    let(:scope) { Page }

    context 'no user' do
      let(:user) { nil }

      it 'is permitted' do
        expect(policy).to permit(context, scope)
      end
    end
  end

  permissions :show?, :contact_form? do
    context 'private page' do
      let(:scope) { FactoryGirl.create(:page, :private, site: site) }

      include_examples 'user record policy'
    end

    context 'non private page' do
      let(:scope) { FactoryGirl.create(:page, site: site) }

      context 'no user' do
        let(:user) { nil }

        it 'is permitted' do
          expect(policy).to permit(context, scope)
        end
      end
    end
  end

  permissions :create?, :update?, :destroy? do
    let(:scope) { FactoryGirl.create(:page, site: site) }

    include_examples 'user record policy'
  end
end
