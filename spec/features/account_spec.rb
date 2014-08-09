require 'rails_helper'

RSpec.describe 'account', type: :feature  do
  include_context 'default_site'
  include_context 'new_fields'

  describe 'edit' do
    let(:go_to_url) { '/account/edit' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      it 'has icon' do
        expect(page).to have_selector 'h1 i.icon-user'
      end

      it 'updates account' do
        expect(find_field('Email')['autofocus']).to eq 'autofocus'
        expect(find_field('Email').value).to eq @account.email
        expect(find_field('Password').value).to be_nil
        expect(find_field('Confirm password').value).to be_nil

        within 'a[href="http://www.gravatar.com"]' do
          gravatar_image = find('img')

          expect(gravatar_image['src']).to eq @account.gravatar_url(size: 150)

          expect(gravatar_image['alt']).to eq 'Profile Image'
          expect(gravatar_image['width']).to eq '150'
          expect(gravatar_image['height']).to eq '150'
        end

        fill_in 'Email', with: " #{new_email} "
        fill_in 'Password', with: new_password
        fill_in 'Confirm password', with: new_password
        click_button 'Update Account'

        it_should_be_on_home_page
        it_should_have_alert_with 'Account successfully updated'

        account = Account.find_by_id(@account.id)
        expect(account.email).to eq new_email

        visit '/logout'
        visit_page '/login'

        fill_in 'Email', with: new_email
        fill_in 'Password', with: new_password

        click_button 'Login'

        it_should_be_on_home_page
      end

      it 'fails with invalid data' do
        fill_in 'Email', with: ''
        click_button 'Update Account'
        it_should_have_form_error "can't be blank"
      end

      it 'has cancel button' do
        click_link 'Cancel'
        it_should_be_on_home_page
      end

      it 'has link in topbar' do
        visit_page '/home'

        within('#topbar') do
          click_link 'Account'
        end

        expect(current_path).to eq '/account/edit'
      end
    end
  end

  describe 'sites' do
    let(:go_to_url) { '/account/sites' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      context 'with multiple sites' do
        before do
          account = Account.find_by_id(@account.id)
          account.sites += [new_host]
          account.save!

          visit_page go_to_url
        end

        it 'has icon' do
          expect(page).to have_selector 'h1 i.icon-list'
        end

        it 'lists the accounts sites' do
          expect(page).to have_link 'localhost', href: 'http://localhost'
          expect(page).to have_link new_host, href: "http://#{new_host}"
        end

        it 'has link in topbar' do
          visit_page '/home'

          within('#topbar') do
            click_link 'Sites'
          end

          expect(current_path).to eq '/account/sites'
        end
      end

      context 'with one site' do
        it 'has no link in topbar' do
          expect(page).to have_no_link 'Sites'
        end
      end
    end
  end
end
