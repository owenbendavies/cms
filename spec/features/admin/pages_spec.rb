require 'rails_helper'

RSpec.feature 'Admin pages' do
  def navigate_to_admin_pages
    click_link 'Admin'
    click_link 'Pages'
  end

  def navigate_to_edit_page
    navigate_to_admin_pages
    find('span', text: home_page.name).click
  end

  before do
    login_as site_user
    visit '/home'
  end

  scenario 'changing the content' do
    home_page.update!(html_content: '<p>Hello world</p>')
    navigate_to_edit_page

    find('.ql-editor').send_keys(' today')
    sleep 1
    click_button 'Save'
    expect(page).to have_content 'Element updated'
    visit '/home'
    expect(page).to have_content 'Hello world today'
  end

  scenario 'renaming a page' do
    navigate_to_edit_page

    url_field = find('#url')
    expect(url_field['disabled']).to eq 'true'
    expect(url_field.value).to eq home_page.url

    expect(find_field('Name').value).to eq home_page.name
    fill_in 'Name', with: 'New Page Name'
    click_button 'Save'
    expect(page).to have_content 'Element updated'
    visit '/new_page_name'
    expect(page).to have_content 'New Page Name'
  end

  scenario 'making the page private' do
    navigate_to_edit_page

    expect(find('input#private', visible: false)).not_to be_checked
    find('label', text: 'Private').click
    click_button 'Save'
    expect(page).to have_content 'Element updated'
    visit '/home'
    expect(page).to have_selector 'h1 svg.fa-lock.fa-fw'
  end

  scenario 'adding a contact form' do
    navigate_to_edit_page

    expect(find('input#contactForm', visible: false)).not_to be_checked
    find('label', text: 'Contact form').click
    click_button 'Save'
    expect(page).to have_content 'Element updated'
    visit '/home'
    expect(page).to have_content 'Message'
  end

  scenario 'deleteing a page' do
    navigate_to_edit_page
    click_button 'Delete'
    click_button 'Confirm'
    expect(page).to have_content 'Element deleted'
  end

  scenario 'creating a page' do
    navigate_to_admin_pages
    click_link 'Create'
    fill_in 'Name', with: 'New Page'
    click_button 'Save'
    expect(page).to have_content 'Element created'
    visit '/new_page'
    expect(page).to have_content 'New Page'
  end

  it_behaves_like 'when on mobile' do
    scenario 'navigating to page' do
      click_button 'Account menu'
      click_link 'Admin'
      find('button[title="Open menu"]').click
      click_link 'Pages'

      within('.list-page ul a:nth-child(1)') do
        expect(page).to have_content home_page.name
      end

      find('span', text: home_page.name).click

      expect(page).to have_content "Page #{home_page.name}"
    end
  end

  context 'with multiple pages' do
    let!(:pages) do
      ('a'..'k').map do |i|
        FactoryBot.create(:page, name: "Page #{i}", site: site)
      end
    end

    scenario 'clicking pagination' do
      navigate_to_admin_pages

      expect(page).to have_content pages.first.name
      expect(page).not_to have_content pages.last.name

      expect(all('table tbody tr').size).to eq 10

      click_button 'Next'

      expect(page).not_to have_content pages.first.name
      expect(page).to have_content pages.last.name

      click_button 'Prev'

      expect(page).to have_content pages.first.name
      expect(page).not_to have_content pages.last.name
    end

    scenario 'deleteing pages' do
      navigate_to_admin_pages

      find('table tbody tr:nth-child(1) td:nth-child(1) > span').click
      find('table tbody tr:nth-child(2) td:nth-child(1) > span').click
      find('table tbody tr:nth-child(3) td:nth-child(1) > span').click

      click_button 'Delete'
      click_button 'Confirm'

      expect(page).to have_content '3 elements deleted'
    end
  end
end
