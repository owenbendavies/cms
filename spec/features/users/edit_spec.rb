require 'rails_helper'

RSpec.feature 'Editing a user' do
  let(:go_to_url) { '/user/edit' }

  include_examples 'authenticated page'

  as_a 'logged in user' do
    scenario 'changing the password' do
      expect(find_field('Current password')['autofocus']).to eq 'autofocus'
      expect(find_field('Current password')['autocomplete']).to eq 'off'
      expect(find_field('Password').value).to be_nil
      expect(find_field('Password')['autocomplete']).to eq 'off'
      expect(find_field('Confirm password').value).to be_nil
      expect(find_field('Confirm password')['autocomplete']).to eq 'off'

      fill_in 'Current password', with: user.password
      fill_in 'Password', with: new_password
      fill_in 'Confirm password', with: new_password
      click_button 'Update User'

      expect(current_path).to eq '/home'
      expect(page).to have_content 'Your account has been updated'

      expect(ActionMailer::Base.deliveries.size).to eq 0
      Delayed::Worker.new.work_off
      expect(ActionMailer::Base.deliveries.size).to eq 0

      visit_page '/logout'
      visit_200_page '/login'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: new_password
      click_button 'Login'

      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'changing the name' do
      expect(find_field('Name').value).to eq user.name

      fill_in 'Current password', with: user.password
      fill_in 'Name', with: " #{new_name} "
      click_button 'Update User'

      expect(current_path).to eq '/home'
      expect(page).to have_content 'Your account has been updated'

      visit_200_page go_to_url

      expect(find_field('Name').value).to eq new_name
    end

    scenario 'changing the email' do
      within 'a[href="https://www.gravatar.com"]' do
        gravatar_image = find('img')

        expect(gravatar_image['src']).to eq user.gravatar_url(size: 150)

        expect(gravatar_image['alt']).to eq 'Profile Image'
        expect(gravatar_image['width']).to eq '150'
        expect(gravatar_image['height']).to eq '150'
      end

      old_email = user.email
      expect(find_field('Email').value).to eq user.email

      fill_in 'Current password', with: user.password
      fill_in 'Email', with: " #{new_email} "
      click_button 'Update User'

      expect(page).to have_content 'we need to verify your new email address'
      expect(current_path).to eq '/home'

      expect(ActionMailer::Base.deliveries.size).to eq 0
      Delayed::Worker.new.work_off
      expect(ActionMailer::Base.deliveries.size).to eq 1

      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq [new_email]
      expect(email.subject).to eq 'Confirmation instructions'

      user.reload
      expect(user.email).to eq old_email
      expect(user.unconfirmed_email).to eq new_email

      link = email.html_part.body.match(/href="([^"]+)/)[1]
      expect(link).to include site.host

      visit_page link

      expect(page).to have_content 'Your email address has been successfully confirmed.'

      user.reload
      expect(user.email).to eq new_email

      within '#cms-topbar' do
        image = find('img')
        expect(image['src']).to eq user.gravatar_url
        expect(image['alt']).to eq 'Profile Image'
      end
    end

    scenario 'without current password' do
      fill_in 'Email', with: new_email

      click_button 'Update User'

      expect(page).to have_content "can't be blank"
    end

    scenario 'with invalid data' do
      fill_in 'Current password', with: user.password
      fill_in 'Email', with: ''

      click_button 'Update User'

      expect(page).to have_content "can't be blank"
    end

    scenario 'clicking Cancel' do
      click_link 'Cancel'
      expect(current_path).to eq '/home'
    end

    include_examples 'page with topbar link', 'User Settings', 'user'
  end
end
