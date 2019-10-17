require 'rails_helper'

RSpec.feature 'Editing a page' do
  before do
    home_page.update!(html_content: '<p>Hello world</p>')

    login_as site_user
    navigate_via_topbar menu: 'Page', title: 'Edit', icon: 'svg.fa-edit.fa-fw'

    find('.mce-content-body')
  end

  scenario 'changing the content' do
    expect(body).to include home_page.html_content

    find('.mce-content-body').send_keys(' today')

    click_button 'Update Page'

    expect(page).to have_content 'Page successfully updated'
    expect(page).to have_content 'Hello world today'
    expect(home_page.reload.html_content).to eq '<p>Hello world today</p>'
  end

  scenario 'making the page private' do
    expect(find_field('Private')).not_to be_checked
    check 'Private'
    click_button 'Update Page'

    expect(page).to have_selector 'h1 svg.fa-lock.fa-fw'

    navigate_via_topbar menu: 'Page', title: 'Edit', icon: 'svg.fa-edit.fa-fw'
    expect(find_field('page[private]')).to be_checked
  end

  scenario 'adding a contact form' do
    expect(find_field('page[contact_form]')).not_to be_checked
    check 'Contact Form'
    click_button 'Update Page'

    navigate_via_topbar menu: 'Page', title: 'Edit', icon: 'svg.fa-edit.fa-fw'
    expect(find_field('page[contact_form]')).to be_checked
  end

  scenario 'renaming a page' do
    url_field = find('#page_url')
    expect(url_field['disabled']).to eq 'true'
    expect(url_field.value).to eq home_page.url

    expect(find_field('Name').value).to eq home_page.name
    expect(find_field('Name')['autofocus']).to eq 'true'

    fill_in 'Name', with: 'New Page Name'
    click_button 'Update Page'

    expect(page).to have_current_path '/new_page_name'
  end

  scenario 'invalid data' do
    fill_in 'page[name]', with: 'Admin'
    click_button 'Update Page'
    expect(page).to have_content "Url\nis reserved"
  end

  scenario 'clicking Cancel' do
    click_link 'Cancel'
    expect(page).to have_current_path '/home'
  end
end
