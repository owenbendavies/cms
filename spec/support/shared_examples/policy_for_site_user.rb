RSpec.shared_examples 'policy for site user' do
  include_examples 'policy for no user'

  context 'with site user' do
    let(:user) { FactoryBot.create(:user, site: site) }

    it 'is permitted' do
      expect(described_class).to permit(context, record)
    end
  end
end
