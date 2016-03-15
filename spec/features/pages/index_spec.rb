require 'rails_helper'

RSpec.feature 'Pages index' do
  let!(:private_page) { FactoryGirl.create(:private_page) }

  context 'html' do
    let(:go_to_url) { '/sitemap' }

    scenario 'visiting the page' do
      visit_200_page

      expect(page).to have_link 'Home', href: '/home'
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
      scenario 'with a private page' do
        visit_200_page

        expect(page).to have_no_link private_page.name
      end
    end

    as_a 'authorized user', :site_user do
      scenario 'with a private page' do
        visit_200_page

        find('ul#cms-sitemap li:nth-child(2)').tap do |item|
          expect(item).to have_link private_page.name, href: '/private'
          expect(item).to have_selector '.fa-lock'
        end
      end
    end
  end

  context 'xml' do
    let(:go_to_url) { '/sitemap.xml' }

    scenario 'visiting the page' do
      visit_200_page

      expect(find(:xpath, '//urlset/url[1]/loc').text).to eq 'https://localhost/home'

      updated_at = home_page.updated_at.iso8601

      expect(find(:xpath, '//urlset/url[1]/lastmod').text).to eq updated_at

      expect(page).to have_no_xpath('//loc', text: "https://localhost/#{private_page.url}")
    end
  end
end
