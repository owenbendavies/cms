RSpec.shared_examples 'policy for site admin' do
  include_examples 'policy for no user'

  context 'with site user' do
    let(:user) { build(:user, site: site) }

    it 'is not permitted' do
      expect(described_class).not_to permit(context, record)
    end
  end

  context 'with admin user' do
    let(:user) { build(:user, :admin) }

    it 'is permitted' do
      expect(described_class).to permit(context, record)
    end
  end
end
