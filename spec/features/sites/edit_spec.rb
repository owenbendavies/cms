require 'rails_helper'

RSpec.feature 'Edit the site' do
  let(:go_to_url) { '/site/edit' }

  it_behaves_like 'restricted page'

  it_behaves_like 'logged in user' do
    scenario 'filling in valid data' do
      host_field = find('#site_host')
      expect(host_field.value).to eq 'localhost'
      expect(host_field['disabled']).to eq 'disabled'

      expect(find_field('Name').value).to eq site.name
      expect(find_field('Name')['autofocus']).to eq 'autofocus'
      expect(find_field('Sub title').value).to eq site.sub_title
      expect(find_field('Layout').value).to eq site.layout
      expect(find_field('Separate header')).to be_checked

      expect(find_field('Copyright').value).to eq site.copyright
      expect(find_field('Charity number').value).to eq site.charity_number
      expect(find_field('Main menu')).to_not be_checked

      expect(find_field('Facebook').value).to eq site.facebook
      expect(find_field('Twitter').value).to eq site.twitter
      expect(find_field('YouTube').value).to eq site.youtube
      expect(find_field('LinkedIn').value).to eq site.linkedin
      expect(find_field('GitHub').value).to eq site.github

      fill_in 'Name', with: "  #{new_company_name} "
      fill_in 'Sub title', with: "  #{new_catch_phrase} "
      select 'Right sidebar', from: 'Layout'
      uncheck 'Separate header'

      fill_in 'Copyright', with: " #{new_name} "
      fill_in 'Charity number', with: " #{new_number} "
      check 'Main menu'

      fill_in 'Facebook', with: " #{new_facebook} "
      fill_in 'Twitter', with: " #{new_twitter} "
      fill_in 'YouTube', with: " #{new_youtube} "
      fill_in 'LinkedIn', with: "  #{new_linkedin} "
      fill_in 'GitHub', with: "  #{new_github} "

      click_button 'Update Site'

      expect(current_path).to eq '/home'
      expect(page).to have_content 'Site successfully updated'

      site.reload
      expect(site.name).to eq new_company_name
      expect(site.sub_title).to eq new_catch_phrase
      expect(site.layout).to eq 'right_sidebar'
      expect(site.updated_by).to eq user
      expect(site.separate_header).to eq false

      expect(site.copyright).to eq new_name
      expect(site.charity_number).to eq new_number.to_s
      expect(site.main_menu_in_footer).to eq true

      expect(site.facebook).to eq new_facebook
      expect(site.twitter).to eq new_twitter
      expect(site.youtube).to eq new_youtube
      expect(site.linkedin).to eq new_linkedin
      expect(site.github).to eq new_github
    end

    scenario 'adding Google Analytics' do
      expect(body).to_not include "ga('create',"
      expect(find_field('Google Analytics').value).to eq site.google_analytics

      new_code = "UA-#{Faker::Number.number(3)}-#{Faker::Number.digit}"

      fill_in 'Google Analytics', with: "  #{new_code} "
      click_button 'Update Site'

      expect(current_path).to eq '/home'
      expect(page).to have_content 'Site successfully updated'

      site.reload

      expect(site.google_analytics).to eq new_code

      expect(body).to include(
        "ga('create', '#{site.google_analytics}', 'auto');"
      )

      expect(body).to include("ga('set', '&uid', '#{user.id}');")
    end

    scenario 'filling in empty copyright' do
      fill_in 'Copyright', with: ''
      click_button 'Update Site'

      site = Site.find_by_host!('localhost')
      expect(site.copyright).to be_nil
    end

    scenario 'filling in invalid data' do
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
