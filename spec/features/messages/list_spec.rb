require 'rails_helper'

RSpec.feature 'List messages' do
  let!(:message) do
    FactoryGirl.create(
      :message,
      created_at: Time.zone.now - 1.month - 3.days,
      updated_at: Time.zone.now - 1.month - 3.days
    )
  end

  let!(:other_site_message) do
    FactoryGirl.create(:message, site: FactoryGirl.create(:site))
  end

  let(:go_to_url) { '/site/messages' }

  include_examples 'restricted page with topbar link', 'Messages'

  it_behaves_like 'logged in site user' do
    scenario 'visiting the page', js: true do
      expect(page).to have_content 'Created at'
      expect(page).to have_content 'Name'
      expect(page).to have_content 'Email'

      expect(page).to have_link('about a month ago', href: "/site/messages/#{message.id}")
      expect(page).to have_link(message.name, href: "/site/messages/#{message.id}")
      expect(page).to have_link(message.email, href: "/site/messages/#{message.id}")

      expect(page).to_not have_content other_site_message.name
    end

    include_examples 'page with topbar link', 'Messages', 'envelope'
  end
end
