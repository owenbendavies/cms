require 'rails_helper'

RSpec.describe UserPolicy do
  describe 'Scope' do
    subject(:policy_scope) { described_class::Scope.new(context, User).resolve }

    let(:user) { FactoryBot.create(:user, site: site) }

    before { FactoryBot.create(:user) }

    it 'returns sites users' do
      expect(policy_scope).to contain_exactly user
    end
  end

  permissions :index?, :create? do
    include_examples 'policy for site user'
  end
end
