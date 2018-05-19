require 'rails_helper'

RSpec.feature 'Creating a page' do
  before do
    login_as site_user
    navigate_via_topbar menu: 'Page', title: 'New Page', icon: 'svg.fa-plus.fa-fw'

    find('.mce-content-body')
  end

  scenario 'valid data' do
    fill_in 'Name', with: new_name

    find('.mce-content-body').click
    find('.mce-content-body').base.send_keys(new_message)

    click_button 'Create Page'
    expect(page).to have_content new_name

    new_page = Page.find_by!(site_id: site.id, name: new_name)
    expect(new_page.html_content).to eq "<p>#{new_message}</p>"
  end

  scenario 'invalid data' do
    fill_in 'Name', with: 'Admin'
    click_button 'Create Page'

    expect(page).to have_content 'Url is reserved'
  end
end
