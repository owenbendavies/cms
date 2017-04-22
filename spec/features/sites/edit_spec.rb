require 'rails_helper'

RSpec.feature 'Edit the site' do
  before do
    login_as site_user
    navigate_via_topbar menu: 'Site', title: 'Site Settings', icon: 'cog'
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

    navigate_via_topbar menu: 'Site', title: 'Site Settings', icon: 'cog'

    expect(find_field('Sub title').value).to eq new_catch_phrase
  end

  scenario 'adding Google Analytics' do
    expect(body).not_to include "ga('create',"

    new_code = "UA-#{Faker::Number.number(3)}-#{Faker::Number.digit}"

    fill_in 'Google Analytics', with: "  #{new_code} "
    click_button 'Update Site'

    expect(page).to have_content 'Site successfully updated'
    expect(body).to include "ga('create', '#{new_code}', 'auto');"
    expect(body).to include "ga('set', 'userId', '#{site_user.uuid}');"

    navigate_via_topbar menu: 'Site', title: 'Site Settings', icon: 'cog'

    expect(find_field('Google Analytics').value).to eq new_code
  end

  scenario 'adding a copyright' do
    fill_in 'Copyright', with: " #{new_name} "
    click_button 'Update Site'

    expect(page).to have_content 'Site successfully updated'
    expect(page).to have_content "#{site.copyright} © #{Time.zone.now.year}"

    navigate_via_topbar menu: 'Site', title: 'Site Settings', icon: 'cog'

    expect(find_field('Copyright').value).to eq new_name
  end

  scenario 'adding a charity number' do
    fill_in 'Charity number', with: " #{new_number} "
    click_button 'Update Site'

    expect(page).to have_content 'Site successfully updated'
    expect(page).to have_content "Registered charity number #{new_number}"

    navigate_via_topbar menu: 'Site', title: 'Site Settings', icon: 'cog'

    expect(find_field('Charity number').value).to eq new_number.to_s
  end

  scenario 'invalid data' do
    fill_in 'Google Analytics', with: 'bad'
    click_button 'Update Site'

    expect(page).to have_content 'Google Analytics is invalid'
  end

  scenario 'clicking Cancel' do
    click_link 'Cancel'
    expect(current_path).to eq '/home'
  end
end
