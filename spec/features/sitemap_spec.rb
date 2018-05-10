require 'rails_helper'

RSpec.feature 'Sitemap' do
  let!(:hidden_page) { FactoryBot.create(:page, :hidden, site: site) }
  let!(:private_page) { FactoryBot.create(:page, :private, site: site) }

  context 'with html' do
    scenario 'not logged in' do
      visit '/home'

      within('footer') do
        click_link 'Sitemap'
      end

      expect(page).to have_link 'Home', href: '/home'
      expect(page).to have_no_link hidden_page.name
      expect(page).to have_no_link private_page.name
    end

    scenario 'site user' do
      login_as site_user
      navigate_via_topbar menu: 'Site', title: 'Sitemap', icon: 'svg.fa-sitemap.fa-fw'

      hidden_index = site.pages.ordered.find_index(hidden_page) + 1

      find(".sitemap li:nth-child(#{hidden_index})").tap do |item|
        expect(item).to have_link hidden_page.name, href: "/#{hidden_page.url}"
        expect(item).to have_selector 'svg.fa-eye-slash.fa-fw'
      end

      private_index = site.pages.ordered.find_index(private_page) + 1

      find(".sitemap li:nth-child(#{private_index})").tap do |item|
        expect(item).to have_link private_page.name, href: "/#{private_page.url}"
        expect(item).to have_selector 'svg.fa-lock.fa-fw'
      end
    end
  end

  context 'with xml', js: false do
    scenario 'http' do
      visit '/sitemap.xml'

      expect(find(:xpath, '//urlset/url[1]/loc').text).to eq 'http://localhost/home'
      expect(find(:xpath, '//urlset/url[1]/lastmod').text).to eq home_page.updated_at.iso8601
      expect(page).to have_no_xpath('//loc', text: "http://localhost/#{hidden_page.url}")
      expect(page).to have_no_xpath('//loc', text: "http://localhost/#{private_page.url}")
    end

    scenario 'https' do
      ClimateControl.modify(DISABLE_SSL: nil) do
        visit '/sitemap.xml'
      end

      expect(find(:xpath, '//urlset/url[1]/loc').text).to eq 'https://localhost/home'
    end
  end
end
