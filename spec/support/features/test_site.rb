RSpec.shared_context 'test site' do
  let!(:site) { FactoryGirl.create(:site, host: 'localhost') }

  let(:site_user) do
    FactoryGirl.create(:user).tap do |user|
      user.site_settings.create!(site: site)
    end
  end

  let(:site_admin) do
    FactoryGirl.create(:user).tap do |user|
      user.site_settings.create!(site: site, admin: true)
    end
  end

  let(:user) { FactoryGirl.create(:user) }

  let(:sysadmin) { FactoryGirl.create(:user, :sysadmin) }

  let!(:home_page) { FactoryGirl.create(:page, name: 'Home', site: site) }
end

RSpec.configuration.include_context 'test site', type: :feature
