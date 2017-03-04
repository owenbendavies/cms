require 'rails_helper'

RSpec.feature 'Sitemap' do
  let!(:hidden_page) { FactoryGirl.create(:page, :hidden, site: site) }
  let!(:private_page) { FactoryGirl.create(:page, :private, site: site) }

  context 'html', js: true do
    scenario 'when not logged in' do
      visit_200_page '/home'

      within('#cms-footer-links') do
        click_link 'Sitemap'
      end

      expect(page).to have_link 'Home', href: '/home'
      expect(page).to have_no_link hidden_page.name
      expect(page).to have_no_link private_page.name
    end

    scenario 'as a site user' do
      login_as site_user
      navigate_via_topbar menu: 'Site', title: 'Sitemap', icon: 'sitemap'

      hidden_index = site.pages.ordered.find_index(hidden_page) + 1

      find("ul#cms-sitemap li:nth-child(#{hidden_index})").tap do |item|
        expect(item).to have_link hidden_page.name, href: "/#{hidden_page.url}"
        expect(item).to have_selector '.fa-eye-slash'
      end

      private_index = site.pages.ordered.find_index(private_page) + 1

      find("ul#cms-sitemap li:nth-child(#{private_index})").tap do |item|
        expect(item).to have_link private_page.name, href: "/#{private_page.url}"
        expect(item).to have_selector '.fa-lock'
      end
    end
  end

  context 'xml' do
    scenario 'with http' do
      visit_200_page '/sitemap.xml'

      expect(find(:xpath, '//urlset/url[1]/loc').text).to eq 'http://localhost/home'
      expect(find(:xpath, '//urlset/url[1]/lastmod').text).to eq home_page.updated_at.iso8601
      expect(page).to have_no_xpath('//loc', text: "http://localhost/#{hidden_page.url}")
      expect(page).to have_no_xpath('//loc', text: "http://localhost/#{private_page.url}")
    end

    scenario 'with https' do
      ClimateControl.modify(DISABLE_SSL: nil) do
        visit_200_page '/sitemap.xml'
      end

      expect(find(:xpath, '//urlset/url[1]/loc').text).to eq 'https://localhost/home'
    end
  end
end
