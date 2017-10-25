require 'rails_helper'

RSpec.feature 'Site main menu' do
  let(:main_menu) { '.main-menu' }
  let(:footer_main_menu) { '.footer-main-menu' }

  context 'with main menu' do
    let(:test_page) { FactoryBot.create(:page, name: 'Test Page', site: site) }

    before do
      home_page.insert_at(1)
      test_page.insert_at(1)
    end

    scenario 'navigating to page via main menu' do
      visit_200_page '/home'

      within main_menu do
        expect(page).to have_link 'Home', href: '/home'
        expect(page).to have_selector 'a.cms-page-link-home'
        expect(page).to have_link 'Test Page', href: '/test_page'
        expect(page).to have_selector 'a.cms-page-link-test_page'

        click_link 'Test Page'
      end

      expect(current_path).to eq '/test_page'
    end

    scenario 'adding main menu to footer' do
      login_as site_user
      navigate_via_topbar menu: 'Site', title: 'Site Settings', icon: 'cog'

      expect(page).not_to have_selector footer_main_menu
      expect(find_field('Main menu')).not_to be_checked

      check 'Main menu'
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'

      within footer_main_menu do
        expect(page).to have_link 'Home', href: '/home'
        expect(page).to have_selector 'a.cms-page-link-home'
        expect(page).to have_link 'Test Page', href: '/test_page'
        expect(page).to have_selector 'a.cms-page-link-test_page'
      end

      navigate_via_topbar menu: 'Site', title: 'Site Settings', icon: 'cog'

      expect(find_field('Main menu')).to be_checked
    end
  end

  scenario 'no main menu' do
    site.update! main_menu_in_footer: true
    visit_200_page '/home'

    expect(page).not_to have_selector main_menu
    expect(page).not_to have_selector footer_main_menu
  end
end
