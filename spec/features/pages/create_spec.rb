require 'rails_helper'

RSpec.feature 'Creating a page' do
  before do
    login_as site_user
    navigate_via_topbar menu: 'Page', title: 'New Page', icon: 'plus'
  end

  scenario 'valid data' do
    fill_in 'Name', with: new_name

    find('.mce-content-body')
    find('.js-tinymce').click
    find('.js-tinymce').base.send_keys(new_message)

    expect do
      click_button 'Create Page'
      expect(page).to have_content new_name
    end.to change(Page, :count).by(1)

    new_page = Page.find_by!(site_id: site.id, name: new_name)
    expect(new_page.html_content).to eq "<p>#{new_message}</p>"
  end

  scenario 'invalid data' do
    fill_in 'Name', with: 'Site'
    click_button 'Create Page'

    expect(page).to have_content 'Url is reserved'
  end
end
