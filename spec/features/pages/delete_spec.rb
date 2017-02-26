require 'rails_helper'

RSpec.feature 'Deleting a page', js: true do
  let(:test_page) { FactoryGirl.create(:page, site: site) }

  before do
    login_as site_user
    visit_200_page "/#{test_page.url}"
  end

  scenario 'clicking yes' do
    expect do
      message = accept_confirm do
        click_topbar_link(menu: 'Page', title: 'Delete', icon: 'trash')
      end

      expect(message).to eq("Are you sure you want to delete page '#{test_page.name}'?")
    end.to change(Page, :count).by(-1)

    expect(page).to have_content "#{test_page.name} was deleted"
  end

  scenario 'clicking no', js: true do
    expect do
      dismiss_confirm do
        click_topbar_link(menu: 'Page', title: 'Delete', icon: 'trash')
      end
    end.not_to change(Page, :count)
  end
end
