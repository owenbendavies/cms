RSpec.shared_examples 'policy for no user' do
  context 'without user' do
    it 'is not permitted' do
      expect(described_class).not_to permit(context, record)
    end
  end

  context 'without site' do
    let(:context) do
      {
        user:,
        site: nil
      }
    end

    let(:user) { build(:user, site:) }

    it 'is not permitted' do
      expect(described_class).not_to permit(context, record)
    end
  end
end
