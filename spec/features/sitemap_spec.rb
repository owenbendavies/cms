require 'rails_helper'

describe 'sitemap' do
  include_context 'default_site'
  before do
    site = Site.find_by_host('localhost')
    site.main_menu = []
    site.save!

    @private_page = FactoryGirl.create(
      :page,
      name: 'Private',
      site_id: @site.id,
      private: true
    )
  end

  describe 'show' do
    context 'html' do
      let(:go_to_url) { '/sitemap' }

      it_behaves_like 'non logged in account' do
        it 'has icon' do
          expect(page).to have_selector 'h1 i.icon-sitemap'
        end

        it 'has page url on body' do
          its_body_id_should_be 'page_url_sitemap'
        end

        it 'has link to pages' do
          expect(page).to have_link 'Home', href: '/home'
        end

        it 'does not show private pages' do
          expect(page).to have_no_link @private_page.name
        end

        it 'has link in footer' do
          visit_page '/home'

          within('#footer_links') do
            click_link 'Sitemap'
          end

          expect(current_path).to eq '/sitemap'
        end
      end

      it_behaves_like 'logged in account' do
        it 'has lock icon for private pages' do
          find('ul#sitemap li:nth-child(2)').tap do |item|
            expect(item).to have_link @private_page.name, href: '/private'
            expect(item).to have_selector 'i[class="icon-lock"]'
          end
        end

        it 'has link in topbar' do
          visit_page '/home'

          within('#topbar') do
            click_link 'Sitemap'
          end

          expect(current_path).to eq '/sitemap'
        end
      end
    end

    context 'xml' do
      before { visit_page '/sitemap.xml' }

      it 'has loc' do
        expect(find(:xpath, '//urlset/url[1]/loc').text).
          to eq 'http://localhost/home'
      end

      it 'has lastmod' do
        expect(find(:xpath, '//urlset/url[1]/lastmod').
          text).to eq  '2012-03-12T09:23:05Z'
      end

      it 'does not include private pages' do
        expect(page).to have_no_xpath(
          '//loc',
          text: "http://localhost/#{@private_page.url}"
        )
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
end
