require 'rails_helper'

RSpec.feature 'Editing a page' do
  let(:go_to_url) { '/test_page/edit' }

  include_examples 'restricted page'

  it_behaves_like 'logged in site user' do
    scenario 'editing the content', js: true do
      expect(body).to include test_page.html_content

      page.execute_script("tinyMCE.editors[0].setContent('#{new_message}');")

      click_button 'Update Page'

      expect(current_path).to eq '/test_page'
      expect(page).to have_content new_message

      page = Page.find_by_site_id_and_url!(site, 'test_page')
      expect(page.updated_by).to eq site_user
    end

    scenario 'making the page private' do
      expect(find_field('Private')).not_to be_checked
      check 'Private'
      click_button 'Update Page'

      expect(current_path).to eq '/test_page'
      expect(page).to have_selector 'h1 .fa-lock'

      click_link 'Edit'
      expect(find_field('page[private]')).to be_checked
    end

    scenario 'adding a contact form' do
      expect(find_field('page[contact_form]')).not_to be_checked
      check 'Contact Form'
      click_button 'Update Page'

      expect(current_path).to eq '/test_page'
      expect(page).to have_content 'Name'

      click_link 'Edit'
      expect(find_field('page[contact_form]')).to be_checked
    end

    scenario 'renaming a page' do
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
      test_page = Page.find_by_site_id_and_url!(site, 'test_page')
      test_page.updated_by = site_user
      test_page.save!
      test_page.reload

      visit_page '/test_page/edit'

      fill_in 'page[name]', with: test_page.name

      expect do
        click_button 'Update Page'
        expect(current_path).to eq '/test_page'
        test_page.reload
      end.to_not change(test_page, :updated_at)
    end

    scenario 'with invalid data' do
      fill_in 'page[name]', with: 'Site'
      click_button 'Update Page'
      expect(page).to have_content 'is reserved'
    end

    scenario 'clicking Cancel' do
      click_link 'Cancel'
      expect(current_path).to eq '/test_page'
    end

    scenario 'navigating to the page via topbar' do
      visit_page '/test_page'

      expect(page).to have_selector '#cms-topbar .fa-pencil'

      within('#cms-topbar') do
        click_link 'Edit'
      end

      expect(current_path).to eq go_to_url

      expect(page).to have_selector 'h1 .fa-pencil'
    end
  end
end
