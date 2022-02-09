RSpec.shared_examples 'policy for user record' do
  include_examples 'policy for site user'

  context 'with another site' do
    let(:other_site) { build(:site) }
    let(:user) { build(:user, site: other_site) }

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
