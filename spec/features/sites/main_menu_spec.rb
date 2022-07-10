require 'rails_helper'

RSpec.feature 'Site main menu' do
  let(:main_menu) { '.main-menu' }
  let(:footer_main_menu) { '.footer-main-menu' }

  context 'with main menu' do
    let(:test_page) { create(:page, name: 'Test Page', site:) }

    before do
      home_page.insert_at(1)
      test_page.insert_at(1)
    end

    scenario 'navigating to page via main menu' do
      visit '/home'

      within main_menu do
        expect(page).to have_link 'Home', href: '/home'
        expect(page).to have_selector '.cms-page-link-home'
        expect(page).to have_link 'Test Page', href: '/test_page'
        expect(page).to have_selector '.cms-page-link-test_page'

        click_link 'Test Page'
      end

      expect(page).to have_current_path '/test_page'
    end
  end

  scenario 'no main menu' do
    site.update! main_menu_in_footer: true
    visit '/home'

    expect(page).not_to have_selector main_menu
    expect(page).not_to have_selector footer_main_menu
  end
end
