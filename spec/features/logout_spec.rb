require 'rails_helper'

RSpec.feature 'User logout' do
  let(:host) { Capybara.current_session.server.host }
  let(:port) { Capybara.current_session.server.port }

  before do
    allow(Rails.configuration.x).to receive(:aws_cognito_domain).and_return("http://#{host}:#{port}")
    login_with_omniauth_as(site_user)
    visit '/login'
  end

  scenario 'clicking topbar link' do
    within('.topbar') do
      click_link "Logout #{site_user.name}"
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
