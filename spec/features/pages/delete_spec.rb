require 'rails_helper'

RSpec.feature 'Deleting a page' do
  let(:test_page) do
    FactoryBot.create(
      :page,
      site: site
    )
  end

  before do
    login_as site_user
    visit "/#{test_page.url}"
  end

  scenario 'clicking yes' do
    expect do
      message = accept_confirm do
        click_topbar_link(menu: 'Page', title: 'Delete', icon: '.fas.fa-trash.fa-fw')
      end

      expect(message).to eq("Are you sure you want to delete page '#{test_page.name}'?")
      expect(page).to have_content "#{test_page.name} was deleted"
    end.to change(Page, :count).by(-1)
  end

  scenario 'clicking no' do
    expect do
      dismiss_confirm do
        click_topbar_link(menu: 'Page', title: 'Delete', icon: '.fas.fa-trash.fa-fw')
      end
    end.not_to change(Page, :count)
  end
end
