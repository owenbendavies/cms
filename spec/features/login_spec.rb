require 'rails_helper'

RSpec.feature 'Login' do
  scenario 'when successful' do
    login_with_omniauth_as(site_user)
    visit '/login'

    expect(page).to have_content 'Signed in successfully'
  end

  scenario 'when error' do
    OmniAuth.config.mock_auth[:'cognito-idp'] = :invalid_credentials

    visit '/login'

    expect(page).to have_content 'Error signing in'
  end
end
