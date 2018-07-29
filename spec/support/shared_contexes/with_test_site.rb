RSpec.shared_context 'with test site' do
  let!(:site) { FactoryBot.create(:site, host: 'localhost') }

  let(:site_user) { FactoryBot.build(:user, site: site) }

  let(:site_admin) { FactoryBot.build(:user, site: site, site_admin: true) }

  let(:user) { FactoryBot.create(:user) }

  let!(:home_page) { FactoryBot.create(:page, name: 'Home', site: site) }
end

RSpec.configuration.include_context 'with test site', type: :feature
