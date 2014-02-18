require 'spec_helper'

describe 'account' do
  include_context 'default_site'
  include_context 'new_fields'

  describe 'edit' do
    let(:go_to_url) { '/account/edit' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      it 'has icon' do
        page.should have_selector 'h1 i.icon-user'
      end

      it 'updates account' do
        find_field('Email')['autofocus'].should eq 'autofocus'
        find_field('Email').value.should eq @account.email
        find_field('Password').value.should be_nil
        find_field('Confirm password').value.should be_nil

        within 'a[href="http://www.gravatar.com"]' do
          gravatar_image = find('img')

          gravatar_image['src'].should eq @account.gravatar_url(size: 150)

          gravatar_image['alt'].should eq 'Profile Image'
          gravatar_image['width'].should eq '150'
          gravatar_image['height'].should eq '150'
        end

        fill_in 'Email', with: " #{new_email} "
        fill_in 'Password', with: new_password
        fill_in 'Confirm password', with: new_password
        click_button 'Update Account'

        it_should_be_on_home_page
        it_should_have_alert_with 'Account successfully updated'

        account = Account.find_by_id(@account.id)
        account.email.should eq new_email

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

        current_path.should eq '/account/edit'
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
          page.should have_selector 'h1 i.icon-list'
        end

        it 'lists the accounts sites' do
          page.should have_link 'localhost', href: 'http://localhost'
          page.should have_link new_host, href: "http://#{new_host}"
        end

        it 'has link in topbar' do
          visit_page '/home'

          within('#topbar') do
            click_link 'Sites'
          end

          current_path.should eq '/account/sites'
        end
      end

      context 'with one site' do
        it 'has no link in topbar' do
          page.should have_no_link 'Sites'
        end
      end
    end
  end
end
