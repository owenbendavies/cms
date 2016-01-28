require 'rails_helper'

RSpec.feature 'List messages' do
  let!(:messages) do
    (0..11).map do |i|
      FactoryGirl.create(
        :message,
        created_at: Time.zone.now - 1.month - 3.days - i.minutes,
        updated_at: Time.zone.now - 1.month - 3.days - i.minutes
      )
    end
  end

  let!(:other_site_message) do
    FactoryGirl.create(:message, site: FactoryGirl.create(:site))
  end

  let(:go_to_url) { '/site/messages' }

  include_examples 'restricted page with topbar link', 'Messages'

  as_a 'logged in site user' do
    scenario 'visiting the page', js: true do
      expect(page).to have_content 'Created at'
      expect(page).to have_content 'Name'
      expect(page).to have_content 'Email'

      expect(page).to have_link('about a month ago', href: "/site/messages/#{messages.first.id}")
      expect(page).to have_link(messages.first.name, href: "/site/messages/#{messages.first.id}")
      expect(page).to have_link(messages.first.email, href: "/site/messages/#{messages.first.id}")

      expect(page).to_not have_content other_site_message.name
    end

    scenario 'pagination' do
      expect(page).to have_content messages.first.name
      expect(page).to_not have_content messages.last.name

      click_link 2

      expect(page).to_not have_content messages.first.name
      expect(page).to have_content messages.last.name
    end

    include_examples 'page with topbar link', 'Messages', 'envelope'
  end
end
