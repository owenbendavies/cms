require 'rails_helper'

RSpec.describe NotificationsMailer do
  include_context 'with test site'

  describe '.new_message' do
    before do
      site_user
      user
    end

    subject(:email) { described_class.new_message(message) }

    let(:message) { FactoryBot.create(:message, site: site) }

    include_examples 'site email'

    it 'is sent to sites users email' do
      expect(email.to).to eq [site_user.email]
    end

    it 'includes message subject' do
      expect(email.subject).to eq 'New message'
    end

    it 'has text in body' do
      expect(email.body)
        .to have_content "A new message has been posted on #{site.name}:"
    end

    it 'has message name in body' do
      expect(email.body).to have_content message.name
    end

    it 'has message email in body' do
      expect(email.body).to have_content message.email
    end

    it 'has message phone in body' do
      expect(email.body).to have_content message.phone
    end

    it 'has message in body' do
      expect(email.body).to have_content message.message
    end
  end

  describe '.user_added_to_site' do
    subject(:email) { described_class.user_added_to_site(user, site, site_user) }

    include_examples 'site email'

    it 'is sent to users email' do
      expect(email.to).to eq [user.email]
    end

    it 'has subject' do
      expect(email.subject).to eq 'Added to site'
    end

    it 'has users name' do
      expect(email.body).to have_content "Hi #{user.name}"
    end

    it 'has text in body' do
      expect(email.body).to have_content(
        "You have been added to #{site.name} site by #{site_user.name}."
      )
    end
  end
end
