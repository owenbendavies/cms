require 'rails_helper'

RSpec.feature 'Inviting a user' do
  let(:go_to_url) { '/user/invitation/new' }

  include_examples 'restricted page'

  it_behaves_like 'logged in site user' do
    scenario 'for a new user' do
      fill_in 'Name', with: new_name
      fill_in 'Email', with: new_email

      expect(ActionMailer::Base.deliveries.size).to eq 0
      click_button 'Add User'

      expect(page).to have_content "An invitation email has been sent to #{new_email}."

      expect(current_path).to eq '/site/users'

      expect(ActionMailer::Base.deliveries.size).to eq 1

      logout

      user = User.find_by_email! new_email
      expect(user.sites).to eq [site]

      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq [new_email]
      expect(email.subject).to eq 'Invitation instructions'

      link = email.html_part.body.match(/href="([^"]+)/)[1]
      expect(link).to include site.host

      visit_page link

      expect(page).to have_content 'Set Password'

      fill_in 'New password', with: new_password
      fill_in 'Confirm password', with: new_password

      click_button 'Set Password'

      expect(page).to have_content 'Your password was set successfully'

      logout

      visit_page '/login'
      fill_in 'Email', with: new_email
      fill_in 'Password', with: new_password
      click_button 'Login'
      expect(page).to have_content 'Signed in successfully.'

      visit_page '/site/users'
    end

    scenario 'for an existing user' do
      fill_in 'Name', with: new_name
      fill_in 'Email', with: user.email

      expect(ActionMailer::Base.deliveries.size).to eq 0
      click_button 'Add User'

      expect(current_path).to eq '/site/users'

      expect(ActionMailer::Base.deliveries.size).to eq 1

      logout

      expect(user.sites).to eq [site]

      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq [user.email]
      expect(email.subject).to eq 'Added to site'

      visit_page '/login'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'
      expect(page).to have_content 'Signed in successfully.'

      visit_page '/site/users'
    end

    scenario 'for an existing site user' do
      user = FactoryGirl.create(:user)

      SiteSetting.create!(
        user: user,
        site: site,
        created_by: admin,
        updated_by: admin
      )

      fill_in 'Name', with: new_name
      fill_in 'Email', with: user.email
      click_button 'Add User'

      expect(ActionMailer::Base.deliveries.size).to eq 0
      expect(page).to have_content 'has already been taken'
    end

    scenario 'for an admin' do
      fill_in 'Name', with: new_name
      fill_in 'Email', with: admin.email
      click_button 'Add User'

      expect(ActionMailer::Base.deliveries.size).to eq 0
      expect(page).to have_content 'has already been taken'
    end

    scenario 'with invalid data' do
      fill_in 'Name', with: 'a'
      fill_in 'Email', with: new_email
      click_button 'Add User'

      expect(ActionMailer::Base.deliveries.size).to eq 0
      expect(page).to have_content 'is too short'
    end

    scenario 'visiting the page via link' do
      visit_page '/site/users'

      expect(page).to have_selector '.fa-user-plus'

      click_link 'Add User'

      within '#cms-article-header' do
        expect(page).to have_content 'Add User'
        expect(page).to have_selector '.fa-user-plus'
      end
    end
  end
end
