RSpec.shared_context 'test site' do
  let!(:site) { FactoryGirl.create(:site, host: 'localhost') }

  let(:site_user) { FactoryGirl.create(:user, site: site) }

  let(:site_admin) { FactoryGirl.create(:user, site: site, site_admin: true) }

  let(:user) { FactoryGirl.create(:user) }

  let!(:home_page) { FactoryGirl.create(:page, name: 'Home', site: site) }
end

RSpec.configuration.include_context 'test site', type: :feature
