require 'rails_helper'

RSpec.feature 'User login via Google' do
  let(:link_name) { 'Sign in with Google' }

  context 'when enabled' do
    let(:environment_variables) do
      {
        GOOGLE_CLIENT_ID: Faker::Internet.password,
        GOOGLE_CLIENT_SECRET: Faker::Internet.password
      }
    end

    before do
      OmniAuth.config.test_mode = true

      visit '/login'
    end

    scenario 'existing user with matching email' do
      uid = Faker::Number.number(8)

      OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(
        uid: uid,
        info: { email: user.email }
      )

      click_link link_name

      expect(page).to have_content 'Successfully authenticated from Google'

      expect(user.reload.google_uid).to eq uid
    end

    scenario 'existing user with matching Google uid' do
      user.update! google_uid: Faker::Number.number(8)

      OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(
        uid: user.google_uid,
        info: { email: Faker::Internet.email }
      )

      click_link link_name

      expect(page).to have_content 'Successfully authenticated from Google'
    end

    scenario 'new user' do
      OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(
        uid: Faker::Number.number(8),
        info: { email: Faker::Internet.email }
      )

      click_link link_name

      expect(page).to have_content(
        'Could not authenticate you from Google because "Invalid credentials"'
      )
    end

    scenario 'invalid Google account' do
      OmniAuth.config.mock_auth[:google] = :invalid_credentials

      click_link link_name

      expect(page).to have_content(
        'Could not authenticate you from Google because "Invalid credentials"'
      )
    end
  end

  scenario 'not enabled' do
    visit '/login'
    expect(page).not_to have_link link_name
  end
end
