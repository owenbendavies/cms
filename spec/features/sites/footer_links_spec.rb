require 'rails_helper'

RSpec.feature 'Footer links' do
  let(:css_selector) { 'footer #cms-site-footer-links' }

  scenario 'site with footer links' do
    link1 = FactoryGirl.create(:footer_link, site: site)
    FactoryGirl.create(:footer_link, site: site, icon: 'facebook-official')

    visit_200_page '/home'

    expect(page).to have_selector css_selector
    expect(page).to have_link link1.name, href: link1.url

    within css_selector do
      expect(page).to have_selector '.fa-facebook-official'
    end
  end

  scenario 'site without footer links' do
    visit_200_page '/home'

    expect(page).not_to have_selector css_selector
  end
end
