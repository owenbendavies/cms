RSpec.shared_context 'with policy context' do
  let(:record) { nil }
  let(:site) { create :site }
  let(:user) { nil }

  let(:context) do
    {
      user: user,
      site: site
    }
  end
end

RSpec.configuration.include_context 'with policy context', type: :policy
