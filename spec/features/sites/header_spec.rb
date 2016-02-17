require 'rails_helper'

RSpec.feature 'Site header' do
  let(:go_to_url) { '/site/edit' }

  before do
    home_page.insert_at(1)
  end

  as_a 'authorized user' do
    scenario 'removing separate header' do
      visit_200_page

      within '#cms-main-menu' do
        expect(page).not_to have_link site.name, href: '/home'
      end

      within '#cms-header #cms-site-name' do
        expect(page).to have_link site.name, href: '/home'
      end

      expect(page).not_to have_selector '#cms-main-menu .nav.navbar-right'

      expect(find_field('Separate header')).to be_checked

      uncheck 'Separate header'
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'

      within '#cms-main-menu' do
        expect(page).to have_link site.name, href: '/home'
      end

      expect(page).not_to have_selector '#cms-header'

      expect(page).to have_selector '#cms-main-menu .nav.navbar-right'

      visit_200_page

      expect(find_field('Separate header')).not_to be_checked
    end
  end
end
