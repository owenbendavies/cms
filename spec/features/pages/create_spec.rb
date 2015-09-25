require 'rails_helper'

RSpec.feature 'Creating a page' do
  let(:go_to_url) { '/new' }

  include_examples 'restricted page with topbar link', 'New Page'

  as_a 'logged in site user' do
    scenario 'with valid data', js: true do
      expect(page).to have_no_content 'last updated'

      fill_in 'Name', with: 'New Page'

      page.execute_script("tinyMCE.editors[0].setContent('#{new_message}');")

      expect do
        click_button 'Create Page'
        expect(page).to have_content 'New Page'
      end.to change(Page, :count).by(1)

      new_page = Page.find_by_site_id_and_url!(site, 'new_page')
      expect(new_page.name).to eq 'New Page'
      expect(new_page.html_content).to eq "<p>#{new_message}</p>"
    end

    scenario 'with invalid data' do
      fill_in 'Name', with: 'Site'
      click_button 'Create Page'

      expect(current_path).to eq '/'
      expect(page).to have_content 'is reserved'
    end

    scenario 'clicking Cancel' do
      click_link 'Cancel'
      expect(current_path).to eq '/home'
    end

    include_examples 'page with topbar link', 'New Page', 'plus'
  end
end
