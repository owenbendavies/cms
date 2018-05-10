require 'rails_helper'

RSpec.feature 'Editing a user' do
  before do
    login_as site_user
    navigate_via_topbar menu: site_user.name, title: 'User Settings', icon: 'svg.fa-user.fa-fw'
  end

  scenario 'changing the password' do
    expect(find_field('Current password')['autofocus']).to eq 'true'
    expect(find_field('Current password')['autocomplete']).to eq 'off'
    expect(find_field('Password').value).to be_blank
    expect(find_field('Password')['autocomplete']).to eq 'off'
    expect(find_field('Confirm password').value).to be_blank
    expect(find_field('Confirm password')['autocomplete']).to eq 'off'

    fill_in 'Current password', with: site_user.password
    fill_in 'Password', with: new_password
    fill_in 'Confirm password', with: new_password
    click_button 'Update User'

    expect(page).to have_content 'Your account has been updated'

    email = last_email
    expect(email.to).to eq [site_user.email]
    expect(email.subject).to eq 'Password Changed'

    visit '/logout'
    visit '/login'
    fill_in 'Email', with: site_user.email
    fill_in 'Password', with: new_password
    click_button 'Login'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'changing the name' do
    expect(find_field('Name').value).to eq site_user.name

    fill_in 'Current password', with: site_user.password
    fill_in 'Name', with: " #{new_name} "
    click_button 'Update User'

    expect(page).to have_content 'Your account has been updated'

    navigate_via_topbar menu: new_name, title: 'User Settings', icon: 'svg.fa-user.fa-fw'

    expect(find_field('Name').value).to eq new_name
  end

  scenario 'changing the email' do
    within 'a[href="https://www.gravatar.com"]' do
      gravatar_image = find('img')

      expect(gravatar_image['src']).to eq site_user.gravatar_url(size: 150)

      expect(gravatar_image['alt']).to eq 'Profile Image'
      expect(gravatar_image['width']).to eq '150'
      expect(gravatar_image['height']).to eq '150'
    end

    old_email = site_user.email
    expect(find_field('Email').value).to eq site_user.email

    fill_in 'Current password', with: site_user.password
    fill_in 'Email', with: " #{new_email} "
    click_button 'Update User'

    expect(page).to have_content 'we need to verify your new email address'

    emails = last_emails(2)
    expect(emails.first.subject).to eq 'Email Changed'
    expect(emails.first.to).to eq [old_email]

    expect(emails.last.subject).to eq 'Confirmation instructions'
    expect(emails.last.to).to eq [new_email]

    visit emails.last.html_part.body.match(/href="([^"]+)/)[1]

    expect(page).to have_content 'Your email address has been successfully confirmed.'

    within '.topbar' do
      image = find('img')
      expect(image['src']).to eq site_user.reload.gravatar_url
      expect(image['alt']).to eq 'Profile Image'
    end
  end

  scenario 'incorect current password' do
    fill_in 'Current password', with: new_password
    fill_in 'Email', with: new_email
    click_button 'Update User'

    expect(page).to have_content 'Current password is invalid'
  end

  scenario 'invalid data' do
    fill_in 'Current password', with: site_user.password
    fill_in 'Email', with: 'bad@email'
    click_button 'Update User'

    expect(page).to have_content 'Email is not a valid email'
  end

  scenario 'clicking Cancel' do
    click_link 'Cancel'
    expect(page).to have_current_path '/home'
  end
end
