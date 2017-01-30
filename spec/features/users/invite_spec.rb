# TODO: refactor

require 'rails_helper'

RSpec.feature 'Inviting a user' do
  let(:go_to_url) { '/user/invitation/new' }

  authenticated_page do
    scenario 'for a new user' do
      visit_200_page
      fill_in 'Name', with: new_name
      fill_in 'Email', with: new_email

      click_button 'Add User'

      expect(page).to have_content "An invitation email has been sent to #{new_email}."
      expect(current_path).to eq '/site/users'

      logout

      user = User.find_by!(email: new_email)
      expect(user.sites).to eq [site]

      expect(ActionMailer::Base.deliveries.size).to eq 0
      Delayed::Worker.new.work_off
      expect(ActionMailer::Base.deliveries.size).to eq 1

      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq [new_email]
      expect(email.subject).to eq 'Invitation instructions'

      link = email.html_part.body.match(/href="([^"]+)/)[1]
      expect(link).to include site.host

      visit_200_page link

      expect(page).to have_content 'Set Password'

      expect(find_field('New password')['autocomplete']).to eq 'off'
      expect(find_field('Confirm password')['autocomplete']).to eq 'off'

      fill_in 'New password', with: new_password
      fill_in 'Confirm password', with: new_password

      click_button 'Set Password'

      expect(page).to have_content 'Your password was set successfully'

      expect(ActionMailer::Base.deliveries.size).to eq 1
      Delayed::Worker.new.work_off
      expect(ActionMailer::Base.deliveries.size).to eq 2

      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq [new_email]
      expect(email.subject).to eq 'Password Changed'
      logout

      visit_200_page '/login'
      fill_in 'Email', with: new_email
      fill_in 'Password', with: new_password
      click_button 'Login'
      expect(page).to have_content 'Signed in successfully.'

      visit_200_page '/site/users'
    end

    scenario 'for an existing user' do
      visit_200_page
      fill_in 'Name', with: new_name
      fill_in 'Email', with: user.email
      click_button 'Add User'

      expect(current_path).to eq '/site/users'

      logout

      expect(user.sites).to eq [site]

      expect(ActionMailer::Base.deliveries.size).to eq 0
      Delayed::Worker.new.work_off
      expect(ActionMailer::Base.deliveries.size).to eq 1

      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq [user.email]
      expect(email.subject).to eq 'Added to site'

      visit_200_page '/login'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'
      expect(page).to have_content 'Signed in successfully.'

      visit_200_page '/site/users'
    end

    scenario 'for an existing site user' do
      user = FactoryGirl.create(:user)

      user.site_settings.create!(site: site)

      visit_200_page
      fill_in 'Name', with: new_name
      fill_in 'Email', with: user.email
      click_button 'Add User'

      expect(page).to have_content 'has already been taken'

      expect(ActionMailer::Base.deliveries.size).to eq 0
      Delayed::Worker.new.work_off
      expect(ActionMailer::Base.deliveries.size).to eq 0
    end

    scenario 'with invalid data' do
      visit_200_page
      fill_in 'Name', with: 'a'
      fill_in 'Email', with: new_email
      click_button 'Add User'

      expect(page).to have_content 'is too short'

      expect(ActionMailer::Base.deliveries.size).to eq 0
      Delayed::Worker.new.work_off
      expect(ActionMailer::Base.deliveries.size).to eq 0
    end

    scenario 'visiting the page via link' do
      visit_200_page '/site/users'

      expect(page).to have_selector '.fa-user-plus'

      click_link 'Add User'

      within '#cms-article-header' do
        expect(page).to have_content 'Add User'
        expect(page).to have_selector '.fa-user-plus'
      end
    end
  end
end
