RSpec.shared_context 'with test site' do
  let(:site) { FactoryBot.create(:site, host: Capybara.server_host) }

  let(:site_user) { FactoryBot.build(:user, site: site) }

  let(:admin_user) { FactoryBot.build(:user, :admin) }

  let(:user) { FactoryBot.build(:user) }

  let(:home_page) { FactoryBot.create(:page, name: 'Home', site: site) }
end

RSpec.configuration.include_context 'with test site', type: :feature
