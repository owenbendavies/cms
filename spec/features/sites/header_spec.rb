require 'rails_helper'

RSpec.feature 'Site header' do
  let(:go_to_url) { '/site/edit' }

  before do
    home_page.insert_at(1)
    test_page.insert_at(1)
  end

  it_behaves_like 'logged in site user' do
    scenario 'removing separate header' do
      within '#cms-main-menu' do
        expect(page).to_not have_link site.name, href: '/home'
      end

      within '#cms-header #cms-site-name' do
        expect(page).to have_link site.name, href: '/home'
      end

      expect(page).to_not have_selector '#cms-main-menu .nav.navbar-right'

      expect(find_field('Separate header')).to be_checked

      uncheck 'Separate header'
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'

      within '#cms-main-menu' do
        expect(page).to have_link site.name, href: '/home'
      end

      expect(page).to_not have_selector '#cms-header'

      expect(page).to have_selector '#cms-main-menu .nav.navbar-right'

      visit_200_page go_to_url

      expect(find_field('Separate header')).to_not be_checked
    end
  end
end
