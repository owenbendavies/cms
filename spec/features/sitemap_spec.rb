require 'spec_helper'

describe 'sitemap' do
  include_context 'default_site'
  before do
    site = Site.find_by_host!('localhost')
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
          page.should have_selector 'h1 i.icon-sitemap'
        end

        it 'has page url on body' do
          its_body_id_should_be 'page_url_sitemap'
        end

        it 'has link to pages' do
          page.should have_link 'Home', href: '/home'
        end

        it 'does not show private pages' do
          page.should_not have_link @private_page.name
        end

        it 'has link in footer' do
          visit_page '/home'

          within('#footer_links') do
            click_link 'Sitemap'
          end

          current_path.should eq '/sitemap'
        end
      end

      it_behaves_like 'logged in account' do
        it 'has lock icon for private pages' do
          find('ul#sitemap li:nth-child(2)').tap do |item|
            item.should have_link @private_page.name, href: '/private'
            item.should have_selector 'i[class="icon-lock"]'
          end
        end

        it 'has link in topbar' do
          visit_page '/home'

          within('#topbar') do
            click_link 'Sitemap'
          end

          current_path.should eq '/sitemap'
        end
      end
    end

    context 'xml' do
      before { visit_page '/sitemap.xml' }

      it 'has loc' do
        find(:xpath, '//urlset/url[1]/loc').text.
          should eq 'http://localhost/home'
      end

      it 'has lastmod' do
        find(:xpath, '//urlset/url[1]/lastmod').
          text.should eq  '2012-03-12T09:23:05Z'
      end

      it 'does not include private pages' do
        page.should_not have_xpath(
          '//loc',
          text: "http://localhost/#{@private_page.url}"
        )
      end
    end

    context 'unknown format' do
      it 'renders page not found' do
        visit '/sitemap.txt'
        page.status_code.should eq 404
        page.should have_content 'Page Not Found'
      end
    end
  end
end
