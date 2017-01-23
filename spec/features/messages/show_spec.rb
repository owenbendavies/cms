require 'rails_helper'

RSpec.feature 'Showing a message' do
  let!(:message) do
    FactoryGirl.create(
      :message,
      site: site,
      created_at: Time.zone.now - 1.month - 3.days,
      updated_at: Time.zone.now - 1.month - 3.days
    )
  end

  let(:go_to_url) { "/site/messages/#{message.uuid}" }

  authenticated_page do
    scenario 'visiting the page', js: true do
      visit_200_page

      within '#cms-article-header' do
        expect(page).to have_content 'Message'
        expect(page).to have_selector '.fa-envelope'
      end

      expect(page).to have_content 'about a month ago'
      expect(page).to have_content message.name
      expect(page).to have_content message.email
      expect(page).to have_content message.phone
      expect(page).to have_content message.message
    end

    scenario 'message from another site' do
      message = FactoryGirl.create(:message)

      visit_404_page "/site/messages/#{message.uuid}"
    end

    scenario 'unknown message' do
      visit_404_page '/site/messages/bad'
    end
  end
end
