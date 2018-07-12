require 'rails_helper'

RSpec.describe NotificationsMailer do
  let(:site) { FactoryBot.create(:site) }

  describe '.new_message' do
    subject(:email) { described_class.new_message(message) }

    let!(:site_user1) { FactoryBot.create(:user, site: site) }
    let!(:site_user2) { FactoryBot.create(:user, site: site) }
    let(:message) { FactoryBot.create(:message, site: site) }
    let(:expected_subject) { 'New message' }

    let(:expected_body) do
      <<~BODY
        A new message has been posted on #{site.name}:

        Name
        #{message.name}
        Email
        #{message.email}
        Phone
        #{message.phone}
        Privacy policy agreed
        Yes
        Message
        #{message.message}
      BODY
    end

    include_examples 'email for site'

    it 'is sent to sites users email' do
      expect(email.to).to contain_exactly(site_user1.email, site_user2.email)
    end
  end
end
