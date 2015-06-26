require 'rails_helper'

RSpec.describe 'header and main menu', type: :feature do
  context 'site with main menu' do
    before do
      site.main_menu_page_ids = [home_page.id, test_page.id]
    end

    context 'site with separate header' do
      it 'has separate header' do
        site.save!
        visit_page '/home'

        within '#cms-header #cms-site-name' do
          expect(page).to have_link site.name, href: '/home'
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

        within '#cms-main-menu' do
          expect(page).to_not have_link site.name, href: '/home'
        end
      end
    end

    context 'site without separate header' do
      before do
        site.separate_header = false
      end

      it 'has site name in main menu' do
        site.save!
        visit_page '/home'

        within '#cms-main-menu' do
          expect(page).to have_link site.name, href: '/home'
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
        expect(page).to_not have_selector '#cms-header'
      end
    end
  end
end
