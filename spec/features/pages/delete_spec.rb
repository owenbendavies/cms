require 'rails_helper'

RSpec.feature 'Deleting a page' do
  let!(:test_page) { FactoryGirl.create(:page, name: 'Test Page', site: site) }

  let(:go_to_url) { '/test_page' }

  as_a 'authorized user' do
    scenario 'clicking yes', js: true do
      visit_200_page

      click_link 'Page'

      expect(page).to have_selector '#cms-topbar .fa-trash'

      expect do
        message = accept_confirm { click_link 'Delete' }
        expect(message).to eq("Are you sure you want to delete page 'Test Page'?")
      end.to change(Page, :count).by(-1)

      expect(page).to have_content 'Test Page was deleted'

      expect(current_path).to eq '/sitemap'
      expect(Page.find_by(site_id: site, url: 'test_page')).to be_nil
    end

    scenario 'clicking no', js: true do
      visit_200_page
      click_link 'Page'

      expect do
        dismiss_confirm { click_link 'Delete' }
      end.not_to change(Page, :count)

      expect(current_path).to eq '/test_page'
      expect(Page.find_by(site_id: site.id, url: 'test_page')).to eq test_page
    end
  end
end
