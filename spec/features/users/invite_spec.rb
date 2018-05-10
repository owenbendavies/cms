require 'rails_helper'

RSpec.feature 'Inviting a user' do
  before do
    login_as site_user
    navigate_via_topbar menu: 'Site', title: 'Users', icon: 'svg.fa-users.fa-fw'
    click_link 'Add User'
  end

  scenario 'new user' do
    within '.article__header' do
      expect(page).to have_content 'Add User'
      expect(page).to have_selector 'svg.fa-user-plus.fa-fw'
    end

    fill_in 'Name', with: new_name
    fill_in 'Email', with: new_email
    click_button 'Add User'

    expect(page).to have_content "An invitation email has been sent to #{new_email}."

    logout

    email = last_email
    expect(email.to).to eq [new_email]
    expect(email.subject).to eq 'Invitation instructions'

    visit email.html_part.body.match(/href="([^"]+)/)[1]

    expect(page).to have_content 'Set Password'

    expect(find_field('New password')['autocomplete']).to eq 'off'
    expect(find_field('Confirm password')['autocomplete']).to eq 'off'

    fill_in 'New password', with: new_password
    fill_in 'Confirm password', with: new_password

    click_button 'Set Password'

    expect(page).to have_content 'Your password was set successfully'

    logout

    visit '/login'
    fill_in 'Email', with: new_email
    fill_in 'Password', with: new_password
    click_button 'Login'
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'existing user' do
    fill_in 'Name', with: new_name
    fill_in 'Email', with: user.email
    click_button 'Add User'

    expect(page).to have_content 'Users'
    logout

    email = last_email
    expect(email.to).to eq [user.email]
    expect(email.subject).to eq 'Added to site'

    visit '/login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'existing site user' do
    user = FactoryBot.create(:user, site: site)

    fill_in 'Name', with: new_name
    fill_in 'Email', with: user.email
    click_button 'Add User'

    expect(page).to have_content 'has already been taken'
  end

  scenario 'invalid data' do
    fill_in 'Name', with: 'a'
    fill_in 'Email', with: new_email
    click_button 'Add User'

    expect(page).to have_content 'Name is too short'
  end
end
