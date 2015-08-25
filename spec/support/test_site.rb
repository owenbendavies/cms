RSpec.shared_context 'test site', type: :feature do
  let!(:admin) { FactoryGirl.create(:admin) }

  let!(:site) { FactoryGirl.create(:site, host: 'localhost') }

  let(:user) { FactoryGirl.create(:user) }

  let(:site_user) do
    user = FactoryGirl.create(:user)
    user.site_settings.create!(site: site)
    user
  end

  let!(:home_page) { FactoryGirl.create(:page, name: 'Home') }

  let!(:test_page) do
    FactoryGirl.create(
      :page,
      name: 'Test Page',
      created_at: Time.zone.now,
      updated_at: Time.zone.now
    )
  end
end
