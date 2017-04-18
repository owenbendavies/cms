RSpec.shared_context 'policies' do
  subject(:policy) { described_class }

  let(:site) { FactoryGirl.create :site }

  let(:context) do
    {
      user: user,
      site: site
    }
  end
end

RSpec.configuration.include_context 'policies', type: :policy

RSpec.shared_examples 'user site policy' do
  context 'no user' do
    let(:user) { nil }

    it 'is not permitted' do
      expect(policy).not_to permit(context, scope)
    end
  end

  context 'another site user' do
    let(:user) { FactoryGirl.create :user }

    it 'is not permitted' do
      expect(policy).not_to permit(context, scope)
    end
  end

  context 'site user' do
    let(:user) { FactoryGirl.create(:user, site: site) }

    it 'is permitted' do
      expect(policy).to permit(context, scope)
    end
  end
end

RSpec.shared_examples 'user site admin policy' do
  context 'no user' do
    let(:user) { nil }

    it 'is not permitted' do
      expect(policy).not_to permit(context, scope)
    end
  end

  context 'another site user' do
    let(:user) { FactoryGirl.create :user }

    it 'is not permitted' do
      expect(policy).not_to permit(context, scope)
    end
  end

  context 'another site admin user' do
    let(:user) { FactoryGirl.create(:user, site_admin: true) }

    it 'is not permitted' do
      expect(policy).not_to permit(context, scope)
    end
  end

  context 'site user' do
    let(:user) { FactoryGirl.create(:user, site: site) }

    it 'is not permitted' do
      expect(policy).not_to permit(context, scope)
    end
  end

  context 'site admin user' do
    let(:user) { FactoryGirl.create(:user, site: site, site_admin: true) }

    it 'is permitted' do
      expect(policy).to permit(context, scope)
    end
  end
end

RSpec.shared_examples 'user record policy' do
  include_examples 'user site policy'

  context 'another site' do
    let(:other_site) { FactoryGirl.create(:site) }
    let(:user) { FactoryGirl.create(:user, site: other_site) }

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
