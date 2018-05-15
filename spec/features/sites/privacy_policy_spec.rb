require 'rails_helper'

RSpec.feature 'Privacy Policy' do
  let(:css_selector) { '.footer__privacy-policy' }

  let!(:privacy_policy) { FactoryBot.create(:page, site: site) }

  before do
    login_as site_user
    navigate_via_topbar menu: 'Site', title: 'Site Settings', icon: 'svg.fa-cog.fa-fw'
  end

  scenario 'adding a privacy policy' do
    expect(page).not_to have_selector css_selector

    select(privacy_policy.name, from: 'Privacy policy page')
    click_button 'Update Site'

    within css_selector do
      expect(page).to have_link(privacy_policy.name, href: "/#{privacy_policy.url}")
    end

    navigate_via_topbar menu: 'Site', title: 'Site Settings', icon: 'svg.fa-cog.fa-fw'

    expect(page).to have_select('Privacy policy page', selected: privacy_policy.name)
  end
end
