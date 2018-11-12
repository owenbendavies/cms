require 'rails_helper'

RSpec.feature 'Edit the site' do
  before do
    login_as site_user
    navigate_via_topbar menu: 'Site', title: 'Site Settings', icon: 'svg.fa-cog.fa-fw'
  end

  scenario 'changing the name' do
    expect(find_field('Name').value).to eq site.name
    expect(find_field('Name')['autofocus']).to eq 'true'

    fill_in 'Name', with: "  #{new_company_name} "
    click_button 'Update Site'

    expect(page).to have_content 'Site successfully updated'
    expect(page).to have_title new_company_name
  end

  scenario 'removing Google Analytics' do
    expect(body).to include "ga('create', '#{site.google_analytics}', 'auto');"
    expect(body).to include "ga('set', 'userId', '#{site_user.id}');"

    fill_in 'Google Analytics', with: ''
    click_button 'Update Site'

    expect(page).to have_content 'Site successfully updated'

    expect(body).not_to include "ga('create',"
  end

  scenario 'removing a charity number' do
    expect(page).to have_content "Registered charity number #{site.charity_number}"

    fill_in 'Charity number', with: ''
    click_button 'Update Site'

    expect(page).to have_content 'Site successfully updated'

    expect(page).not_to have_content 'Registered charity'
  end

  scenario 'invalid data' do
    fill_in 'Google Analytics', with: 'bad'
    click_button 'Update Site'

    expect(page).to have_content "Google Analytics\nis invalid"
  end

  scenario 'clicking Cancel' do
    click_link 'Cancel'
    expect(page).to have_current_path '/home'
  end
end
