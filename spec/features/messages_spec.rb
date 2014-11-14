require 'rails_helper'

RSpec.describe 'messages', type: :feature do
  include_context 'default_site'

  before do
    Timecop.freeze(Time.now - 1.month - 3.days) do
      @message = FactoryGirl.create(:message, site: @site)
    end
  end

  describe 'index' do
    let(:go_to_url) { '/site/messages' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      it 'has list of messages', js: true do
        expect(find('#main_article h1').text).to eq 'Messages'
        expect(page).to have_selector 'h1 i.glyphicon-envelope'

        expect(page).to have_content 'Created at'
        expect(page).to have_content 'Name'
        expect(page).to have_content 'Email address'

        expect(page).to have_link(
          'about a month ago',
          href: "/site/messages/#{@message.id}"
        )

        expect(page).to have_link(
          @message.name,
          href: "/site/messages/#{@message.id}"
        )

        expect(page).to have_link(
          @message.email_address,
          href: "/site/messages/#{@message.id}"
        )
      end

      it 'has link in topbar' do
        visit_page '/home'

        within('#topbar') do
          click_link 'Messages'
        end

        expect(current_path).to eq go_to_url
      end
    end
  end

  describe 'show' do
    let(:go_to_url) { "/site/messages/#{@message.id}" }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      it 'shows message', js: true do
        expect(find('#main_article h1').text).to eq 'Message'
        expect(page).to have_selector 'h1 i.glyphicon-envelope'

        expect(page).to have_content 'Created at'
        expect(page).to have_content 'about a month ago'

        expect(page).to have_content 'Name'
        expect(page).to have_content @message.name

        expect(page).to have_content 'Email address'
        expect(page).to have_content @message.email_address

        expect(page).to have_content 'Phone number'
        expect(page).to have_content @message.phone_number

        expect(page).to have_content 'Message'
        expect(page).to have_content @message.message
      end

      it 'does not show phone number when blank' do
        @message.phone_number = nil
        @message.save!

        visit "/site/messages/#{@message.id}"
        expect(find('#main_article h1').text).to eq 'Message'

        expect(page).to have_no_content 'Phone number'
      end

      it "renders page not found for unknow message" do
        visit "/site/messages/#{new_id}"
        expect(page.status_code).to eq 404
        expect(page).to have_content 'Page Not Found'
      end
    end
  end
end
