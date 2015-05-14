require 'rails_helper'

RSpec.describe '/sitemap', type: :feature do
  let!(:private_page) do
    FactoryGirl.create(
      :page,
      name: 'Private',
      site: site,
      private: true
    )
  end

  context '.html' do
    let(:go_to_url) { '/sitemap' }

    it_behaves_like 'non logged in user' do
      it 'has link to pages' do
        expect(page).to have_link 'Home', href: '/home'
      end

      it 'does not show private pages' do
        expect(page).to have_no_link private_page.name
      end

      it 'has link in footer' do
        visit_page '/home'

        within('#cms-footer-links') do
          click_link 'Sitemap'
        end

        expect(current_path).to eq go_to_url
      end
    end

    it_behaves_like 'logged in user' do
      it 'has lock icon for private pages' do
        find('ul#cms-sitemap li:nth-child(2)').tap do |item|
          expect(item).to have_link private_page.name, href: '/private'
          expect(item).to have_selector '.fa-lock'
        end
      end

      include_examples 'page with topbar link', 'Sitemap', 'sitemap'
    end
  end

  context '.xml' do
    it 'has loc' do
      visit_page '/sitemap.xml'

      expect(find(:xpath, '//urlset/url[1]/loc').text)
        .to eq 'http://localhost/home'
    end

    it 'has lastmod' do
      visit_page '/sitemap.xml'

      expect(find(:xpath, '//urlset/url[1]/lastmod').text)
        .to eq test_page.updated_at.iso8601
    end

    it 'does not include private pages' do
      visit_page '/sitemap.xml'

      expect(page).to have_no_xpath(
        '//loc',
        text: "http://localhost/#{private_page.url}"
      )
    end

    context 'https' do
      it 'has https links' do
        page.driver.header('X-Forwarded-Proto', 'https')
        visit_page '/sitemap.xml'

        expect(find(:xpath, '//urlset/url[1]/loc').text)
          .to eq 'https://localhost/home'
      end
    end
  end

  context 'unknown format' do
    it 'renders page not found' do
      visit '/sitemap.txt'
      expect(page.status_code).to eq 404
      expect(page).to have_content 'Page Not Found'
    end
  end
end
