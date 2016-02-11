require 'rails_helper'

RSpec.feature 'Editing a page' do
  let(:go_to_url) { '/test_page/edit' }

  authenticated_page do
    scenario 'editing the content', js: true do
      visit_200_page

      expect(body).to include test_page.html_content

      page.execute_script("tinyMCE.editors[0].setContent('#{new_message}');")

      click_button 'Update Page'

      expect(current_path).to eq '/test_page'
      expect(page).to have_content new_message
    end

    scenario 'making the page private' do
      visit_200_page

      expect(find_field('Private')).not_to be_checked
      check 'Private'
      click_button 'Update Page'

      expect(current_path).to eq '/test_page'
      expect(page).to have_selector 'h1 .fa-lock'

      click_link 'Edit'
      expect(find_field('page[private]')).to be_checked
    end

    scenario 'adding a contact form' do
      visit_200_page

      expect(find_field('page[contact_form]')).not_to be_checked
      check 'Contact Form'
      click_button 'Update Page'

      expect(current_path).to eq '/test_page'
      expect(page).to have_content 'Name'

      click_link 'Edit'
      expect(find_field('page[contact_form]')).to be_checked
    end

    scenario 'renaming a page' do
      visit_200_page

      url_field = find('#page_url')
      expect(url_field['disabled']).to eq 'disabled'
      expect(url_field.value).to eq test_page.url

      expect(find_field('Name').value).to eq test_page.name
      expect(find_field('Name')['autofocus']).to eq 'autofocus'

      fill_in 'Name', with: 'New Page Name'
      click_button 'Update Page'

      expect(current_path).to eq '/new_page_name'
    end

    scenario 'saving without edits' do
      test_page.reload
      visit_200_page
      fill_in 'page[name]', with: test_page.name

      expect do
        click_button 'Update Page'
        expect(current_path).to eq '/test_page'
        test_page.reload
      end.to_not change(test_page, :updated_at)
    end

    scenario 'with invalid data' do
      visit_200_page
      fill_in 'page[name]', with: 'Site'
      click_button 'Update Page'
      expect(page).to have_content 'is reserved'
    end

    scenario 'clicking Cancel' do
      visit_200_page
      click_link 'Cancel'
      expect(current_path).to eq '/test_page'
    end

    scenario 'navigating to the page via topbar' do
      visit_200_page '/test_page'

      expect(page).to have_selector '#cms-topbar .fa-pencil'

      within('#cms-topbar') do
        click_link 'Edit'
      end

      expect(current_path).to eq go_to_url

      expect(page).to have_selector 'h1 .fa-pencil'
      within '#cms-article-header' do
        expect(page).to have_selector '.fa-pencil'
        expect(page).to have_content 'Editing Test Page'
      end
    end
  end
end
