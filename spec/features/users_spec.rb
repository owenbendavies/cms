require 'rails_helper'

RSpec.describe '/users', type: :feature do
  describe '/index' do
    let(:go_to_url) { '/site/users' }

    it_behaves_like 'restricted page'

    it_behaves_like 'logged in user' do
      it 'has list of users' do
        within '#cms-article' do
          expect(page).to have_content 'Users'

          expect(page).to have_content 'Email'
          expect(page).to have_content user.email
          expect(page).to have_content site.users.second.email
        end
      end

      include_examples 'page with topbar link', 'Users', 'group'
    end
  end

  describe '/edit' do
    let(:go_to_url) { '/users/edit' }

    it_behaves_like 'restricted page'

    it_behaves_like 'logged in user' do
      it 'updates user password' do
        expect(find_field('Current password')['autofocus']).to eq 'autofocus'
        expect(find_field('Password').value).to be_nil
        expect(find_field('Confirm password').value).to be_nil

        fill_in 'Current password', with: user.password
        fill_in 'Password', with: new_password
        fill_in 'Confirm password', with: new_password
        click_button 'Update User'

        expect(ActionMailer::Base.deliveries.size).to eq 0
        expect(current_path).to eq '/home'
        expect(page).to have_content 'Your account has been updated'

        visit '/logout'
        visit_page '/login'
        fill_in 'Email', with: user.email
        fill_in 'Password', with: new_password
        click_button 'Login'

        expect(current_path).to eq '/home'
      end

      it 'updates users email after confirmation' do
        old_email = user.email
        expect(find_field('Email').value).to eq user.email

        fill_in 'Current password', with: user.password
        fill_in 'Email', with: " #{new_email} "

        expect(ActionMailer::Base.deliveries.size).to eq 0
        click_button 'Update User'
        expect(ActionMailer::Base.deliveries.size).to eq 1

        expect(current_path).to eq '/home'
        expect(page).to have_content 'we need to verify your new email address'

        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq [new_email]
        expect(email.subject).to eq 'Confirmation instructions'

        user.reload
        expect(user.email).to eq old_email
        expect(user.unconfirmed_email).to eq new_email

        link = email.html_part.body.match(/href="([^"]+)/)[1]
        expect(link).to_not be_blank

        link.gsub!(/.*#{site.host}/, '')

        visit link

        expect(page).to have_content(
          'Your email address has been successfully confirmed.'
        )

        user.reload
        expect(user.email).to eq new_email
      end

      it 'has a gravatar image' do
        within 'a[href="https://www.gravatar.com"]' do
          gravatar_image = find('img')

          expect(gravatar_image['src']).to eq user.gravatar_url(size: 150)

          expect(gravatar_image['alt']).to eq 'Profile Image'
          expect(gravatar_image['width']).to eq '150'
          expect(gravatar_image['height']).to eq '150'
        end
      end

      it 'fails when no current password is given' do
        fill_in 'Email', with: new_email

        click_button 'Update User'

        expect(page).to have_content "can't be blank"
      end

      it 'fails with invalid data' do
        fill_in 'Current password', with: user.password
        fill_in 'Email', with: ''

        click_button 'Update User'

        expect(page).to have_content "can't be blank"
      end

      it 'has cancel button' do
        click_link 'Cancel'
        expect(current_path).to eq '/home'
      end

      include_examples 'page with topbar link', 'User Settings', 'user'
    end
  end

  describe '/password/new' do
    let(:go_to_url) { '/users/password/new' }

    it 'sends reset password email' do
      visit_page go_to_url
      expect(page).to have_content 'Forgot your password?'
      fill_in 'Email', with: user.email

      expect(ActionMailer::Base.deliveries.size).to eq 0

      click_button 'Send reset password instructions'

      expect(ActionMailer::Base.deliveries.size).to eq 1

      expect(page).to have_content 'If your email address exists'

      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq [user.email]
      expect(email.subject).to eq 'Reset password instructions'
    end

    it 'has link on login page' do
      visit_page '/login'

      click_link 'Forgot your password?'

      expect(current_path).to eq go_to_url
    end
  end

  describe '/password/edit' do
    let(:token) { user.send_reset_password_instructions }
    let(:go_to_url) { "/users/password/edit?reset_password_token=#{token}" }

    it 'resets users password' do
      visit_page go_to_url

      expect(page).to have_content 'Change password'

      fill_in 'New password', with: new_password
      fill_in 'Confirm new password', with: new_password
      click_button 'Change password'

      expect(page).to have_content 'Your password has been changed'

      user.reload
      expect(user.valid_password?(new_password)).to eq true
    end
  end

  describe '/unlock/new' do
    let(:go_to_url) { '/users/unlock/new' }

    it 're-sends unlock token' do
      user.lock_access!(send_instructions: false)

      visit_page go_to_url

      expect(page).to have_content 'Unlock account'

      fill_in 'Email', with: user.email

      expect(ActionMailer::Base.deliveries.size).to eq 0

      click_button 'Resend unlock instructions'

      expect(ActionMailer::Base.deliveries.size).to eq 1

      expect(page).to have_content 'If your account exists'

      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq [user.email]
      expect(email.subject).to eq 'Unlock instructions'
    end

    it 'does not give away if email exist or not' do
      visit_page go_to_url

      fill_in 'Email', with: new_email
      click_button 'Resend unlock instructions'

      expect(page).to have_content 'If your account exists'

      expect(ActionMailer::Base.deliveries.size).to eq 0
    end
  end

  describe '/unlock' do
    it 'unlocks an account' do
      token = user.lock_access!

      visit "/users/unlock?unlock_token=#{token}"

      expect(page).to have_content 'Your account has been unlocked'
    end
  end
end
