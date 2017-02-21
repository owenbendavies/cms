# TODO: refactor

require 'rails_helper'

RSpec.feature 'Pages index' do
  context 'html' do
    let(:go_to_url) { '/sitemap' }

    scenario 'visiting the page' do
      hidden_page = FactoryGirl.create(:page, :hidden, site: site)
      private_page = FactoryGirl.create(:page, :private, site: site)

      visit_200_page

      expect(page).to have_link 'Home', href: '/home'
      expect(page).to have_no_link hidden_page.name
      expect(page).to have_no_link private_page.name
    end

    scenario 'navigating to the page via footer' do
      visit_200_page '/home'

      within('#cms-footer-links') do
        click_link 'Sitemap'
      end

      expect(current_path).to eq go_to_url
    end

    as_a 'authorized user', :user do
      scenario 'with a hidden page' do
        hidden_page = FactoryGirl.create(:page, :hidden, site: site)

        visit_200_page

        expect(page).to have_no_link hidden_page.name
      end

      scenario 'with a private page' do
        private_page = FactoryGirl.create(:page, :private, site: site)

        visit_200_page

        expect(page).to have_no_link private_page.name
      end
    end

    as_a 'authorized user', :site_user do
      scenario 'with a hidden page' do
        Page.destroy_all
        hidden_page = FactoryGirl.create(:page, :hidden, site: site)

        visit_200_page

        find('ul#cms-sitemap li').tap do |item|
          expect(item).to have_link hidden_page.name, href: "/#{hidden_page.url}"
          expect(item).to have_selector '.fa-eye-slash'
        end
      end

      scenario 'with a private page' do
        Page.destroy_all
        private_page = FactoryGirl.create(:page, :private, site: site)

        visit_200_page

        find('ul#cms-sitemap li').tap do |item|
          expect(item).to have_link private_page.name, href: "/#{private_page.url}"
          expect(item).to have_selector '.fa-lock'
        end
      end
    end
  end

  context 'xml' do
    let(:go_to_url) { '/sitemap.xml' }

    scenario 'visiting the page' do
      hidden_page = FactoryGirl.create(:page, :hidden, site: site)
      private_page = FactoryGirl.create(:page, :private, site: site)

      visit_200_page

      expect(find(:xpath, '//urlset/url[1]/loc').text).to eq 'http://localhost/home'

      updated_at = home_page.updated_at.iso8601

      expect(find(:xpath, '//urlset/url[1]/lastmod').text).to eq updated_at

      expect(page).to have_no_xpath('//loc', text: "http://localhost/#{hidden_page.url}")
      expect(page).to have_no_xpath('//loc', text: "http://localhost/#{private_page.url}")
    end

    context 'when ssl is enabled' do
      let(:environment_variables) { { DISABLE_SSL: nil } }

      scenario 'visiting the page' do
        visit_200_page

        expect(find(:xpath, '//urlset/url[1]/loc').text).to eq 'https://localhost/home'
      end
    end
  end
end
