require 'rails_helper'

RSpec.feature 'Footer links' do
  let(:css_selector) { '.footer__site-links' }

  context 'with with footer links' do
    let!(:site) { FactoryBot.create(:site, :with_links, host: '127.0.0.1') }
    let(:link_name) { site.links.first.fetch('name') }
    let(:link_url) { site.links.first.fetch('url') }

    scenario 'site with footer links' do
      visit '/home'

      within css_selector do
        expect(page).to have_link link_name, href: link_url
        expect(page).to have_selector 'svg.fa-facebook.fa-fw'
      end
    end
  end

  scenario 'site without footer links' do
    visit '/home'

    expect(page).not_to have_selector css_selector
  end
end
