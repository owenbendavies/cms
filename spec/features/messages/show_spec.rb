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

  let(:go_to_url) { "/site/messages/#{message.id}" }

  it_behaves_like 'restricted page'

  it_behaves_like 'logged in user' do
    scenario 'visiting the page', js: true do
      expect(find('#cms-article h1').text).to eq 'Message'
      expect(page).to have_selector 'h1 .fa-envelope'

      expect(page).to have_content 'about a month ago'
      expect(page).to have_content message.name
      expect(page).to have_content message.email
      expect(page).to have_content message.phone
      expect(page).to have_content message.message
    end

    scenario 'unknown message' do
      visit '/site/messages/bad'
      expect(page).to have_content 'Page Not Found'
      expect(page.status_code).to eq 404
    end
  end
end
