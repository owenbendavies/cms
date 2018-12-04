require 'rails_helper'

RSpec.describe NotificationsMailer do
  let(:site) { FactoryBot.build(:site) }

  describe '.new_message' do
    subject(:email) { described_class.new_message(message) }

    let(:message) { FactoryBot.build(:message, site: site) }

    let(:user_emails) { ['siteuser@example.com', 'admin@example.com'] }

    let(:expected_body) do
      <<~BODY
        A new message has been posted on #{site.name}:
        Name #{message.name}
        Email #{message.email}
        Phone #{message.phone}
        Privacy policy agreed Yes
        Message #{message.message}
      BODY
    end

    it 'has from address as site email' do
      expect(email.from).to eq [site.email]
    end

    it 'is sent to sites users email' do
      expect(email.to).to eq user_emails
    end

    it 'has subject' do
      expect(email.subject).to eq 'New message'
    end

    it 'has site name in body' do
      expect(email.body).to have_content site.name
    end

    it 'has body' do
      expect(email.body).to have_content(expected_body.squish, normalize_ws: true)
    end
  end
end
