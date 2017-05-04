require 'rails_helper'

RSpec.feature 'Site header' do
  let(:header) { '.header' }
  let(:main_menu_site_name) { '.main-menu__site-name' }
  let(:main_menu_right_links) { '.main-menu__links.navbar-right' }

  before do
    home_page.insert_at(1)
    login_as site_user
    navigate_via_topbar menu: 'Site', title: 'Site Settings', icon: 'cog'
  end

  scenario 'removing separate header' do
    expect(find_field('Separate header')).to be_checked
    expect(page).to have_selector header
    expect(page).not_to have_selector main_menu_site_name
    expect(page).not_to have_selector main_menu_right_links

    uncheck 'Separate header'
    click_button 'Update Site'

    expect(page).to have_content 'Site successfully updated'

    navigate_via_topbar menu: 'Site', title: 'Site Settings', icon: 'cog'

    expect(find_field('Separate header')).not_to be_checked
    expect(page).not_to have_selector header
    expect(page).to have_selector main_menu_site_name
    expect(page).to have_selector main_menu_right_links
  end
end
