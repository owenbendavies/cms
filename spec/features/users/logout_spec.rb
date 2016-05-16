require 'rails_helper'

RSpec.feature 'User logout' do
  let(:go_to_url) { '/home' }

  as_a 'authorized user' do
    scenario 'clicking topbar link' do
      visit_200_page

      expect(page).to have_selector '#cms-topbar .fa-sign-out'

      within('#cms-topbar') do
        click_link 'Logout'
      end

      expect(page).to have_content 'Signed out successfully.'
      expect(current_path).to eq '/home'
    end

    scenario 'clicking footer link' do
      visit_200_page

      within('#cms-footer-links') do
        click_link 'Logout'
      end

      expect(page).to have_content 'Signed out successfully.'
      expect(current_path).to eq '/home'
    end
  end
end
