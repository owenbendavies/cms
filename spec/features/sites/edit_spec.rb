# TODO: refactor

require 'rails_helper'

RSpec.feature 'Edit the site' do
  let(:go_to_url) { '/site/edit' }

  as_a 'authorized user', :site_user, 'Site Settings', 'cog' do
    scenario 'changing the name' do
      visit_200_page

      expect(find_field('Name').value).to eq site.name
      expect(find_field('Name')['autofocus']).to eq 'autofocus'

      fill_in 'Name', with: "  #{new_company_name} "
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(page).to have_title new_company_name
    end

    scenario 'adding a sub title' do
      visit_200_page
      fill_in 'Sub title', with: "  #{new_catch_phrase} "
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(page).to have_content new_catch_phrase

      visit_200_page

      expect(find_field('Sub title').value).to eq new_catch_phrase
    end

    scenario 'adding Google Analytics' do
      visit_200_page

      expect(body).not_to include "ga('create',"

      new_code = "UA-#{Faker::Number.number(3)}-#{Faker::Number.digit}"

      fill_in 'Google Analytics', with: "  #{new_code} "
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(body).to include "ga('create', '#{new_code}', 'auto');"
      expect(body).to include "ga('set', 'userId', '#{site_user.uuid}');"

      visit_200_page

      expect(find_field('Google Analytics').value).to eq new_code
    end

    scenario 'adding a copyright' do
      visit_200_page
      fill_in 'Copyright', with: " #{new_name} "
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(page).to have_content "#{site.copyright} © #{Time.zone.now.year}"

      visit_200_page

      expect(find_field('Copyright').value).to eq new_name
    end

    scenario 'adding a charity number' do
      visit_200_page
      fill_in 'Charity number', with: " #{new_number} "
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(page).to have_content "Registered charity number #{new_number}"

      visit_200_page

      expect(find_field('Charity number').value).to eq new_number.to_s
    end

    scenario 'with invalid data' do
      visit_200_page
      fill_in 'Name', with: ''
      click_button 'Update Site'

      expect(page).to have_content 'is too short'
    end

    scenario 'clicking Cancel' do
      visit_200_page
      click_link 'Cancel'
      expect(current_path).to eq '/home'
    end
  end
end
