require 'rails_helper'

RSpec.describe UserPolicy do
  describe 'Scope' do
    subject(:policy_scope) { described_class::Scope.new(context, scope).resolve }

    let(:scope) { User }
    let(:user) { FactoryGirl.create(:user, site: site) }

    before { FactoryGirl.create(:user) }

    it 'returns sites users' do
      expect(policy_scope).to contain_exactly user
    end
  end

  permissions :index?, :create? do
    let(:scope) { User }

    include_examples 'user site policy'
  end
end
