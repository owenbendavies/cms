require 'rails_helper'

RSpec.describe '/messages', type: :feature do
  let!(:message) do
    FactoryGirl.create(
      :message,
      site: site,
      created_at: Time.zone.now - 1.month - 3.days,
      updated_at: Time.zone.now - 1.month - 3.days
    )
  end

  describe '/index' do
    let(:go_to_url) { '/site/messages' }

    it_behaves_like 'restricted page'

    it_behaves_like 'logged in user' do
      it 'has list of messages', js: true do
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

  describe '/id' do
    let(:go_to_url) { "/site/messages/#{message.id}" }

    it_behaves_like 'restricted page'

    it_behaves_like 'logged in user' do
      it 'shows message', js: true do
        expect(find('#cms-article h1').text).to eq 'Message'

        expect(page).to have_content 'about a month ago'
        expect(page).to have_content message.name
        expect(page).to have_content message.email
        expect(page).to have_content message.phone
        expect(page).to have_content message.message
      end

      it 'renders page not found for unknow message' do
        visit '/site/messages/bad'
        expect(page.status_code).to eq 404
        expect(page).to have_content 'Page Not Found'
      end

      it 'has icon on page' do
        expect(page).to have_selector 'h1 .fa-envelope'
      end
    end
  end
end
