require 'rails_helper'

RSpec.feature 'Site main menu' do
  context 'with main menu' do
    let(:go_to_url) { '/site/edit' }

    before do
      site.main_menu_page_ids = [home_page.id, test_page.id]
      site.save!
    end

    scenario 'navigating to page via main menu' do
      visit_200_page '/home'

      within '#cms-main-menu' do
        expect(page).to have_link 'Home', href: '/home'
        expect(page).to have_selector 'a.cms-page-link-home'
        expect(page).to have_link 'Test Page', href: '/test_page'
        expect(page).to have_selector 'a.cms-page-link-test_page'

        click_link 'Test Page'
      end

      expect(current_path).to eq '/test_page'
    end

    it_behaves_like 'logged in site user' do
      scenario 'adding main menu to footer' do
        expect(page).to_not have_selector '#cms-footer-main-menu'
        expect(find_field('Main menu')).to_not be_checked

        check 'Main menu'
        click_button 'Update Site'

        expect(page).to have_content 'Site successfully updated'

        within '#cms-footer-main-menu' do
          expect(page).to have_link 'Home', href: '/home'
          expect(page).to have_selector 'a.cms-page-link-home'
          expect(page).to have_link 'Test Page', href: '/test_page'
          expect(page).to have_link 'Test Page', href: '/test_page'
        end

        visit_200_page go_to_url

        expect(find_field('Main menu')).to be_checked
      end
    end
  end

  scenario 'with no main menu' do
    site.main_menu_in_footer = true
    site.save!
    visit_200_page '/test_page'

    expect(page).to_not have_link 'Test Page', href: '/test_page'
    expect(page).to_not have_selector '#cms-main-menu'
    expect(page).to_not have_selector '#cms-footer-main-menu'
  end
end
