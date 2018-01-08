RSpec.shared_context 'with policies' do
  let(:record) { nil }
  let(:site) { FactoryBot.create :site }
  let(:user) { nil }

  let(:context) do
    {
      user: user,
      site: site
    }
  end
end

RSpec.configuration.include_context 'with policies', type: :policy

RSpec.shared_examples 'no user policy' do
  context 'without user' do
    it 'is not permitted' do
      expect(described_class).not_to permit(context, record)
    end
  end

  context 'without site' do
    let(:context) do
      {
        user: user,
        site: nil
      }
    end

    let(:user) { FactoryBot.create(:user, site: site) }

    it 'is not permitted' do
      expect(described_class).not_to permit(context, record)
    end
  end

  context 'with another site user' do
    let(:user) { FactoryBot.create :user }

    it 'is not permitted' do
      expect(described_class).not_to permit(context, record)
    end
  end
end

RSpec.shared_examples 'user site policy' do
  include_examples 'no user policy'

  context 'with site user' do
    let(:user) { FactoryBot.create(:user, site: site) }

    it 'is permitted' do
      expect(described_class).to permit(context, record)
    end
  end
end

RSpec.shared_examples 'user site admin policy' do
  include_examples 'no user policy'

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

RSpec.shared_examples 'user record policy' do
  include_examples 'user site policy'

  context 'with another site' do
    let(:other_site) { FactoryBot.create(:site) }
    let(:user) { FactoryBot.create(:user, site: other_site) }

    let(:context) do
      {
        user: user,
        site: other_site
      }
    end

    it 'is not permitted' do
      expect(described_class).not_to permit(context, record)
    end
  end
end
