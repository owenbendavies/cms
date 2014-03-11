require 'spec_helper'

describe 'messages' do
  include_context 'default_site'
  include_context 'new_fields'

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
        find('#main_article h1').text.should eq 'Messages'
        page.should have_selector 'h1 i.icon-envelope'

        page.should have_content 'Created at'
        page.should have_content 'Name'
        page.should have_content 'Email address'

        page.should have_link(
          'about a month ago',
          href: "/site/messages/#{@message.id}"
        )

        page.should have_link(
          @message.name,
          href: "/site/messages/#{@message.id}"
        )

        page.should have_link(
          @message.email_address,
          href: "/site/messages/#{@message.id}"
        )
      end

      it 'has link in topbar' do
        visit_page '/home'

        within('#topbar') do
          click_link 'Messages'
        end

        current_path.should eq go_to_url
      end
    end
  end

  describe 'show' do
    let(:go_to_url) { "/site/messages/#{@message.id}" }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      it 'shows message', js: true do
        find('#main_article h1').text.should eq 'Message'
        page.should have_selector 'h1 i.icon-envelope'

        page.should have_content 'Created at'
        page.should have_content 'about a month ago'

        page.should have_content 'Name'
        page.should have_content @message.name

        page.should have_content 'Email address'
        page.should have_content @message.email_address

        page.should have_content 'Phone number'
        page.should have_content @message.phone_number

        page.should have_content 'Message'
        page.should have_content @message.message
      end

      it 'does not show phone number when blank' do
        @message.phone_number = nil
        @message.save!

        visit "/site/messages/#{@message.id}"
        find('#main_article h1').text.should eq 'Message'

        page.should have_no_content 'Phone number'
      end

      it "renders page not found for unknow message" do
        visit "/site/messages/#{new_id}"
        page.status_code.should eq 404
        page.should have_content 'Page Not Found'
      end
    end
  end
end
