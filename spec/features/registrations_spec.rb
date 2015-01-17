require 'rails_helper'

RSpec.describe 'user', type: :feature  do
  describe 'edit' do
    let(:go_to_url) { '/user/edit' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in user' do
      it 'has icon' do
        expect(page).to have_selector 'h1 .glyphicon-user'
      end

      it 'updates user' do
        expect(find_field('Email')['autofocus']).to eq 'autofocus'
        expect(find_field('Email').value).to eq user.email
        expect(find_field('Password').value).to be_nil
        expect(find_field('Confirm password').value).to be_nil

        within 'a[href="https://www.gravatar.com"]' do
          gravatar_image = find('img')

          expect(gravatar_image['src']).to eq user.gravatar_url(size: 150)

          expect(gravatar_image['alt']).to eq 'Profile Image'
          expect(gravatar_image['width']).to eq '150'
          expect(gravatar_image['height']).to eq '150'
        end

        fill_in 'Email', with: " #{new_email} "
        fill_in 'Password', with: new_password
        fill_in 'Confirm password', with: new_password
        click_button 'Update User'

        it_should_be_on_home_page
        it_should_have_success_alert_with 'User successfully updated'

        found_user = User.find(user.id)
        expect(found_user.email).to eq new_email

        visit '/logout'
        visit_page '/login'

        fill_in 'Email', with: new_email
        fill_in 'Password', with: new_password

        click_button 'Login'

        it_should_be_on_home_page
      end

      it 'fails with invalid data' do
        fill_in 'Email', with: ''
        click_button 'Update User'
        it_should_have_form_error "can't be blank"
      end

      it 'has cancel button' do
        click_link 'Cancel'
        it_should_be_on_home_page
      end

      it 'has link in topbar' do
        visit_page '/home'

        within('#topbar') do
          click_link 'User Settings'
        end

        expect(current_path).to eq '/user/edit'
      end
    end
  end

  describe 'sites' do
    let(:go_to_url) { '/user/sites' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in user' do
      it 'has icon' do
        expect(page).to have_selector 'h1 .glyphicon-list'
      end

      it 'lists the users sites' do
        expect(page).to have_link 'localhost', href: 'http://localhost'
      end

      it 'has link in topbar' do
        visit_page '/home'

        within('#topbar') do
          click_link 'Sites'
        end

        expect(current_path).to eq '/user/sites'
      end
    end
  end
end
