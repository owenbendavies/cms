require 'rails_helper'

RSpec.feature 'Edit the site' do
  let(:go_to_url) { '/site/edit' }

  it_behaves_like 'restricted page'

  it_behaves_like 'logged in user' do
    scenario 'with valid data' do
      host_field = find('#site_host')
      expect(host_field.value).to eq 'localhost'
      expect(host_field['disabled']).to eq 'disabled'

      expect(find_field('Separate header')).to be_checked

      uncheck 'Separate header'

      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(current_path).to eq '/home'

      site.reload
      expect(site.updated_by).to eq user
      expect(site.separate_header).to eq false
    end

    scenario 'changing the name' do
      expect(find_field('Name').value).to eq site.name
      expect(find_field('Name')['autofocus']).to eq 'autofocus'

      fill_in 'Name', with: "  #{new_company_name} "
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(page).to have_title new_company_name
    end

    scenario 'adding a sub title' do
      fill_in 'Sub title', with: "  #{new_catch_phrase} "
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(page).to have_content new_catch_phrase

      visit_page go_to_url

      expect(find_field('Sub title').value).to eq new_catch_phrase
    end

    scenario 'adding Google Analytics' do
      expect(body).to_not include "ga('create',"

      new_code = "UA-#{Faker::Number.number(3)}-#{Faker::Number.digit}"

      fill_in 'Google Analytics', with: "  #{new_code} "
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(body).to include "ga('create', '#{new_code}', 'auto');"
      expect(body).to include "ga('set', '&uid', '#{user.id}');"

      visit_page go_to_url

      expect(find_field('Google Analytics').value).to eq new_code
    end

    scenario 'adding a copyright' do
      fill_in 'Copyright', with: " #{new_name} "
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(page).to have_content "#{site.copyright} © #{Time.zone.now.year}"

      visit_page go_to_url

      expect(find_field('Copyright').value).to eq new_name
    end

    scenario 'adding a charity number' do
      fill_in 'Charity number', with: " #{new_number} "
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(page).to have_content "Registered charity number #{new_number}"

      visit_page go_to_url

      expect(find_field('Charity number').value).to eq new_number.to_s
    end

    scenario 'with invalid data' do
      fill_in 'Name', with: ''
      click_button 'Update Site'

      expect(page).to have_content "can't be blank"
    end

    scenario 'clicking Cancel' do
      click_link 'Cancel'
      expect(current_path).to eq '/home'
    end

    include_examples 'page with topbar link', 'Site Settings', 'cog'
  end
end
