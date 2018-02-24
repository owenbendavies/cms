RSpec.shared_examples 'policy for site admin' do
  include_examples 'policy for no user'

  context 'with another site admin user' do
    let(:user) { FactoryBot.create(:user, site_admin: true) }

    it 'is not permitted' do
      expect(described_class).not_to permit(context, record)
    end
  end

  context 'with site user' do
    let(:user) { FactoryBot.create(:user, site: site) }

    it 'is not permitted' do
      expect(described_class).not_to permit(context, record)
    end
  end

  context 'with site admin user' do
    let(:user) { FactoryBot.create(:user, site: site, site_admin: true) }

    it 'is permitted' do
      expect(described_class).to permit(context, record)
    end
  end
end
