require 'rails_helper'

RSpec.describe SitePolicy do
  describe 'Scope' do
    subject(:policy_scope) { described_class::Scope.new(context, scope).resolve }

    let(:scope) { Site }
    let(:user) { FactoryGirl.create(:user, site: site) }

    before { FactoryGirl.create(:site) }

    it 'returns users sites' do
      expect(policy_scope).to contain_exactly site
    end
  end

  permissions :index? do
    let(:scope) { Site }

    context 'no user' do
      let(:user) { nil }

      it 'is not permitted' do
        expect(policy).not_to permit(context, scope)
      end
    end

    context 'user' do
      let(:user) { FactoryGirl.create :user }

      it 'is permitted' do
        expect(policy).to permit(context, scope)
      end
    end
  end

  permissions :update? do
    let(:scope) { site }

    include_examples 'user site policy'
  end

  permissions :css? do
    let(:scope) { site }

    include_examples 'user site admin policy'
  end
end
