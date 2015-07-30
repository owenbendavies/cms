require 'rails_helper'

RSpec.feature 'List messages' do
  let!(:message) do
    FactoryGirl.create(
      :message,
      created_at: Time.zone.now - 1.month - 3.days,
      updated_at: Time.zone.now - 1.month - 3.days
    )
  end

  let(:go_to_url) { '/site/messages' }

  it_behaves_like 'restricted page'

  it_behaves_like 'logged in user' do
    scenario 'visiting the page', js: true do
      expect(find('#cms-article h1').text).to eq 'Messages'

      expect(page).to have_content 'Created at'
      expect(page).to have_content 'Name'
      expect(page).to have_content 'Email'

      expect(page).to have_link(
        'about a month ago',
        href: "/site/messages/#{message.id}"
      )

      expect(page).to have_link(
        message.name,
        href: "/site/messages/#{message.id}"
      )

      expect(page).to have_link(
        message.email,
        href: "/site/messages/#{message.id}"
      )
    end

    include_examples 'page with topbar link', 'Messages', 'envelope'
  end
end
