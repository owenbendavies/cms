RSpec.shared_context 'with test site' do
  let(:site) { create(:site, host: Capybara.server_host) }

  let(:site_user) { build(:user, site: site) }

  let(:admin_user) { build(:user, :admin) }

  let(:user) { build(:user) }

  let(:home_page) { create(:page, name: 'Home', site: site) }
end

RSpec.configuration.include_context 'with test site', type: :feature
