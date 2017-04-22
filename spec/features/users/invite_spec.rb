require 'rails_helper'

RSpec.feature 'Inviting a user' do
  before do
    login_as site_user
    navigate_via_topbar menu: 'Site', title: 'Users', icon: 'group'
    click_link 'Add User'

    within '#cms-article-header' do
      expect(page).to have_content 'Add User'
      expect(page).to have_selector '.fa-user-plus'
    end
  end

  scenario 'new user' do
    fill_in 'Name', with: new_name
    fill_in 'Email', with: new_email
    click_button 'Add User'

    expect(page).to have_content "An invitation email has been sent to #{new_email}."

    logout

    email = last_email
    expect(email.to).to eq [new_email]
    expect(email.subject).to eq 'Invitation instructions'

    link = email.html_part.body.match(/href="([^"]+)/)[1]
    expect(link).to include site.host
    link.gsub!("http://#{site.host}", Capybara.app_host)

    visit_200_page link

    expect(page).to have_content 'Set Password'

    expect(find_field('New password')['autocomplete']).to eq 'off'
    expect(find_field('Confirm password')['autocomplete']).to eq 'off'

    fill_in 'New password', with: new_password
    fill_in 'Confirm password', with: new_password

    click_button 'Set Password'

    expect(page).to have_content 'Your password was set successfully'

    email = last_email
    expect(email.to).to eq [new_email]
    expect(email.subject).to eq 'Password Changed'
    logout

    visit_200_page '/login'
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

    visit_200_page '/login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'existing site user' do
    user = FactoryGirl.create(:user, site: site)

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
