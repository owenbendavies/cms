require 'rails_helper'

RSpec.feature 'Footer links' do
  let(:css_selector) { '.footer__site-links' }

  scenario 'site with footer links' do
    link1 = FactoryBot.create(:footer_link, site: site)
    FactoryBot.create(:footer_link, site: site, icon: 'fas fa-facebook fa-fw')

    visit_200_page '/home'

    within css_selector do
      expect(page).to have_link link1.name, href: link1.url
      expect(page).to have_selector '.fas.fa-facebook.fa-fw'
    end
  end

  scenario 'site without footer links' do
    visit_200_page '/home'

    expect(page).not_to have_selector css_selector
  end
end
