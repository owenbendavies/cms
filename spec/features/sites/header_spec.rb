require 'rails_helper'

RSpec.feature 'Site header' do
  let(:header) { '#cms-header' }
  let(:navbar_brand) { '#cms-main-menu .navbar-brand' }
  let(:right_navbar) { '#cms-main-menu .nav.navbar-right' }

  before do
    home_page.insert_at(1)
    login_as site_user
    navigate_via_topbar menu: 'Site', title: 'Site Settings', icon: 'cog'
  end

  scenario 'removing separate header' do
    expect(find_field('Separate header')).to be_checked
    expect(page).to have_selector header
    expect(page).not_to have_selector navbar_brand
    expect(page).not_to have_selector right_navbar

    uncheck 'Separate header'
    click_button 'Update Site'

    expect(page).to have_content 'Site successfully updated'

    navigate_via_topbar menu: 'Site', title: 'Site Settings', icon: 'cog'

    expect(find_field('Separate header')).not_to be_checked
    expect(page).not_to have_selector header
    expect(page).to have_selector navbar_brand
    expect(page).to have_selector right_navbar
  end
end
