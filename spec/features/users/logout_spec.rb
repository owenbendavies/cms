require 'rails_helper'

RSpec.feature 'User logout' do
  let(:go_to_url) { '/home' }

  as_a 'logged in site user' do
    scenario 'clicking topbar link' do
      expect(page).to have_selector '#cms-topbar .fa-sign-out'

      within('#cms-topbar') do
        click_link 'Logout'
      end

      expect(page).to have_content 'Signed out successfully.'
      expect(current_path).to eq '/home'
    end

    scenario 'clicking footer link' do
      within('#cms-footer-links') do
        click_link 'Logout'
      end

      expect(page).to have_content 'Signed out successfully.'
      expect(current_path).to eq '/home'
    end

    scenario 'trying to replay the session' do
      session = response_headers['Set-Cookie']

      within('#cms-topbar') do
        click_link 'Logout'
      end

      expect(page).to have_content 'Signed out successfully.'

      page.driver.header('Cookie', session)

      visit_page '/user/edit'
      expect(current_path).to eq '/login'
    end
  end
end
