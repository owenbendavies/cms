require 'rails_helper'

RSpec.describe 'header and main menu', type: :feature do
  context 'site with main menu' do
    before do
      site.main_menu_page_ids = [home_page.id, test_page.id]
    end

    it 'shows main menu in page' do
      site.save!
      visit_page '/test_page'

      within '#cms-main-menu' do
        expect(page).to have_link 'Home', href: '/home'
        expect(page).to have_selector 'a.cms-page-link-home'
        expect(page).to have_link 'Test Page', href: '/test_page'
        expect(page).to have_selector 'a.cms-page-link-test_page'
      end

      expect(page).to_not have_selector '#cms-footer-main-menu'
    end

    context 'site with separate header' do
      context 'site with header image' do
        it 'has header image' do
          site.save!
          visit_page '/home'
          image = page.find('#cms-site-name a[href="/home"] img')
          expect(image['src']).to eq site.logo.header.url
          expect(image['alt']).to eq site.name
        end
      end

      context 'site without header image' do
        before do
          site.logo_filename = nil
          site.save!
          visit_page '/home'
        end

        it 'does not have header image' do
          expect(page).to_not have_selector '#cms-page-header img'
        end

        it 'has separate header' do
          within '#cms-page-header #cms-site-name' do
            expect(page).to have_link site.name, href: '/home'
          end
        end
      end

      context 'site with sub title' do
        it 'has sub title' do
          site.save!
          visit_page '/home'
          expect(find('#cms-site-sub-title').text).to eq site.sub_title
        end
      end

      context 'site without sub title' do
        it 'does not have sub title' do
          site.sub_title = nil
          site.save!
          visit_page '/home'
          expect(page).to_not have_selector '#cms-site-sub-title'
        end
      end

      it 'does not pull menu to right' do
        site.save!
        visit_page '/home'
        expect(page).to have_selector '#cms-main-menu .nav'
        expect(page).to_not have_selector '#cms-main-menu .nav.navbar-right'
      end

      it 'does not have title in main menu' do
        site.save!
        visit_page '/home'

        expect(page).to_not have_selector '#cms-main-menu img'
      end
    end

    context 'site without separate header' do
      before do
        site.separate_header = false
      end

      context 'site with header image' do
        it 'has header image in main menu' do
          site.save!
          visit_page '/home'
          image = page.find('#cms-main-menu a[href="/home"] img')
          expect(image['src']).to eq site.logo.main_menu.url
          expect(image['alt']).to eq site.name
        end
      end

      context 'site without header image' do
        before do
          site.logo_filename = nil
          site.save!
          visit_page '/home'
        end

        it 'does not have header image' do
          expect(page).to_not have_selector '#cms-page-header img'
        end

        it 'has site name in main menu' do
          within '#cms-main-menu' do
            expect(page).to have_link site.name, href: '/home'
          end
        end
      end

      it 'pulls menu to right' do
        site.save!
        visit_page '/home'
        expect(page).to have_selector '#cms-main-menu .nav.navbar-right'
      end

      it 'does not have header' do
        site.save!
        visit_page '/home'
        expect(page).to_not have_selector '#cms-page-header'
      end
    end

    context 'site with main menu in footer' do
      before do
        site.main_menu_in_footer = true
        site.save!
      end

      it 'shows main menu in footer' do
        visit_page '/test_page'

        within '#cms-footer-main-menu' do
          expect(page).to have_link 'Home', href: '/home'
          expect(page).to have_selector 'a.cms-page-link-home'
          expect(page).to have_link 'Test Page', href: '/test_page'
          expect(page).to have_link 'Test Page', href: '/test_page'
        end
      end
    end
  end

  context 'site with no main menu' do
    before do
      site.main_menu_in_footer = true
      site.main_menu_page_ids = []
      site.save!
      visit_page '/test_page'
    end

    it 'has no main menu' do
      expect(page).to_not have_link 'Test Page', href: '/test_page'
      expect(page).to_not have_selector '#cms-main-menu'
      expect(page).to_not have_selector '#cms-footer-main-menu'
    end
  end
end
