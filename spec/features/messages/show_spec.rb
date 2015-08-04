require 'rails_helper'

RSpec.feature 'Showing a message' do
  let!(:message) do
    FactoryGirl.create(
      :message,
      created_at: Time.zone.now - 1.month - 3.days,
      updated_at: Time.zone.now - 1.month - 3.days
    )
  end

  let(:go_to_url) { "/site/messages/#{message.id}" }

  include_examples 'restricted page'

  it_behaves_like 'logged in site user' do
    scenario 'visiting the page', js: true do
      within '#cms-article-header' do
        expect(page).to have_selector '.fa-envelope'
        expect(page).to have_content 'Message'
      end

      expect(page).to have_content 'about a month ago'
      expect(page).to have_content message.name
      expect(page).to have_content message.email
      expect(page).to have_content message.phone
      expect(page).to have_content message.message
    end

    scenario 'message from another site' do
      message = FactoryGirl.create(:message, site: FactoryGirl.create(:site))

      visit "/site/messages/#{message.id}"
      expect(page).to have_content 'Page Not Found'
      expect(page.status_code).to eq 404
    end

    scenario 'unknown message' do
      visit '/site/messages/bad'
      expect(page).to have_content 'Page Not Found'
      expect(page.status_code).to eq 404
    end
  end
end
