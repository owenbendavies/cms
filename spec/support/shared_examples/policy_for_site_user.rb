RSpec.shared_examples 'policy for site user' do
  include_examples 'policy for no user'

  context 'with site user' do
    let(:user) { build(:user, site:) }

    it 'is permitted' do
      expect(described_class).to permit(context, record)
    end
  end

  context 'with admin user' do
    let(:user) { build(:user, :admin) }

    it 'is permitted' do
      expect(described_class).to permit(context, record)
    end
  end
end
