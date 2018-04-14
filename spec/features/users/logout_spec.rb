require 'rails_helper'

RSpec.feature 'User logout' do
  before do
    login_as site_user
    visit '/home'
  end

  scenario 'clicking topbar link' do
    within('.topbar') do
      click_link site_user.name
      click_link 'Logout'
    end

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'clicking footer link' do
    within('.footer') do
      click_link 'Logout'
    end

    expect(page).to have_content 'Signed out successfully.'
  end
end
