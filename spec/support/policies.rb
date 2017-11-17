RSpec.shared_context 'with policies' do
  subject(:policy) { described_class }

  let(:site) { FactoryBot.create :site }

  let(:context) do
    {
      user: user,
      site: site
    }
  end
end

RSpec.configuration.include_context 'with policies', type: :policy

RSpec.shared_examples 'user site policy' do
  context 'without user' do
    let(:user) { nil }

    it 'is not permitted' do
      expect(policy).not_to permit(context, scope)
    end
  end

  context 'with another site user' do
    let(:user) { FactoryBot.create :user }

    it 'is not permitted' do
      expect(policy).not_to permit(context, scope)
    end
  end

  context 'with site user' do
    let(:user) { FactoryBot.create(:user, site: site) }

    it 'is permitted' do
      expect(policy).to permit(context, scope)
    end
  end
end

RSpec.shared_examples 'user site admin policy' do
  context 'without user' do
    let(:user) { nil }

    it 'is not permitted' do
      expect(policy).not_to permit(context, scope)
    end
  end

  context 'with another site user' do
    let(:user) { FactoryBot.create :user }

    it 'is not permitted' do
      expect(policy).not_to permit(context, scope)
    end
  end

  context 'with another site admin user' do
    let(:user) { FactoryBot.create(:user, site_admin: true) }

    it 'is not permitted' do
      expect(policy).not_to permit(context, scope)
    end
  end

  context 'with site user' do
    let(:user) { FactoryBot.create(:user, site: site) }

    it 'is not permitted' do
      expect(policy).not_to permit(context, scope)
    end
  end

  context 'with site admin user' do
    let(:user) { FactoryBot.create(:user, site: site, site_admin: true) }

    it 'is permitted' do
      expect(policy).to permit(context, scope)
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
      expect(policy).not_to permit(context, scope)
    end
  end
end
