require 'rails_helper'

RSpec.feature 'User logout' do
  before do
    login_as site_user
    visit_200_page '/home'
  end

  scenario 'clicking topbar link' do
    within('#cms-topbar') do
      click_link site_user.name
      click_link 'Logout'
    end

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'clicking footer link' do
    within('#cms-footer-links') do
      click_link 'Logout'
    end

    expect(page).to have_content 'Signed out successfully.'
  end
end
