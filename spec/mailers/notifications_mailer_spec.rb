require 'rails_helper'

RSpec.describe NotificationsMailer do
  let(:site) { build(:site) }

  describe '.new_message' do
    subject(:email) { described_class.new_message(message) }

    let(:message) { build(:message, site:) }

    let(:emails) do
      %w[admin1@example.com admin2@example.com another@example.com siteuser@example.com]
    end

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

    it 'is sent to all site users and admins' do
      expect(email.to).to eq emails
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
