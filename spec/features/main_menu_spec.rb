require 'rails_helper'

RSpec.describe 'main menu', type: :feature do
  before do
    site.main_menu_page_ids = [home_page.id, test_page.id]
    site.main_menu_in_topbar = false
    site.main_menu_in_page = false
    site.main_menu_in_footer = false
  end

  context 'site with main menu in topbar' do
    before do
      site.main_menu_in_topbar = true
      site.save!
    end

    it 'shows main menu in topbar' do
      visit_page '/test_page'

      within '#topbar' do
        expect(page).to have_link 'Home', href: '/home'
        expect(page).to have_link 'Test Page', href: '/test_page'
      end

      expect(page).to_not have_selector '#main_menu'
      expect(page).to_not have_selector '#footer_main_menu'
    end
  end

  context 'site with main menu in page' do
    before do
      site.main_menu_in_page = true
      site.save!
    end

    it 'shows main menu in page' do
      visit_page '/test_page'

      expect(page).to_not have_selector '#topbar'

      within '#main_menu' do
        expect(page).to have_link 'Home', href: '/home'
        expect(page).to have_link 'Test Page', href: '/test_page'
      end

      expect(page).to_not have_selector '#footer_main_menu'
    end
  end

  context 'site with main menu in footer' do
    before do
      site.main_menu_in_footer = true
      site.save!
    end

    it 'shows main menu in footer' do
      visit_page '/test_page'

      expect(page).to_not have_selector '#topbar'
      expect(page).to_not have_selector '#main_menu'

      within '#footer_main_menu' do
        expect(page).to have_link 'Home', href: '/home'
        expect(page).to have_link 'Test Page', href: '/test_page'
      end
    end
  end

  context 'site with no main menu location' do
    before { site.save! }

    it 'has no main menu' do
      visit_page '/test_page'

      expect(page).to_not have_link 'Test Page', href: '/test_page'
      expect(page).to_not have_selector '#topbar'
      expect(page).to_not have_selector '#main_menu'
      expect(page).to_not have_selector '#footer_main_menu'
    end
  end

  context 'site with no main menu' do
    before do
      site.main_menu_in_topbar = true
      site.main_menu_in_page = true
      site.main_menu_in_footer = true
      site.main_menu_page_ids = []
      site.save!
    end

    it 'has no main menu' do
      visit_page '/test_page'

      expect(page).to_not have_link 'Test Page', href: '/test_page'
      expect(page).to_not have_selector '#topbar'
      expect(page).to_not have_selector '#main_menu'
      expect(page).to_not have_selector '#footer_main_menu'
    end
  end
end
