require 'rails_helper'

RSpec.feature 'Editing a page', js: true do
  before do
    login_as site_user
    navigate_via_topbar menu: 'Page', title: 'Edit', icon: 'pencil'
  end

  scenario 'changing the content' do
    expect(body).to include home_page.html_content

    page.execute_script("tinyMCE.editors[0].setContent('#{new_message}');")

    click_button 'Update Page'

    expect(page).to have_content new_message
  end

  scenario 'making the page hidden' do
    expect(find_field('Hidden')).not_to be_checked
    check 'Hidden'
    click_button 'Update Page'

    navigate_via_topbar menu: 'Page', title: 'Edit', icon: 'pencil'
    expect(find_field('Hidden')).to be_checked
  end

  scenario 'making the page private' do
    expect(find_field('Private')).not_to be_checked
    check 'Private'
    click_button 'Update Page'

    expect(page).to have_selector 'h1 .fa-lock'

    navigate_via_topbar menu: 'Page', title: 'Edit', icon: 'pencil'
    expect(find_field('page[private]')).to be_checked
  end

  scenario 'adding a contact form' do
    expect(find_field('page[contact_form]')).not_to be_checked
    check 'Contact Form'
    click_button 'Update Page'

    navigate_via_topbar menu: 'Page', title: 'Edit', icon: 'pencil'
    expect(find_field('page[contact_form]')).to be_checked
  end

  scenario 'renaming a page' do
    url_field = find('#page_url')
    expect(url_field['disabled']).to eq true
    expect(url_field.value).to eq home_page.url

    expect(find_field('Name').value).to eq home_page.name
    expect(find_field('Name')['autofocus']).to eq 'autofocus'

    fill_in 'Name', with: 'New Page Name'
    click_button 'Update Page'

    expect(current_path).to eq '/new_page_name'
  end

  scenario 'with invalid data' do
    fill_in 'page[name]', with: 'Site'
    click_button 'Update Page'
    expect(page).to have_content 'is reserved'
  end

  scenario 'clicking Cancel' do
    click_link 'Cancel'
    expect(current_path).to eq '/home'
  end
end
