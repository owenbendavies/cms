require 'rails_helper'

RSpec.describe NotificationsMailer do
  include_context 'test site'

  describe '.new_message' do
    before do
      site_user
      user
    end

    subject { described_class.new_message(message) }

    let(:message) { FactoryGirl.create(:message, site: site) }

    include_examples 'site email'

    it 'is sent to sites users email' do
      expect(subject.to).to eq [site_user.email]
    end

    it 'includes message subject' do
      expect(subject.subject).to eq message.subject
    end

    it 'has text in body' do
      expect(subject.body)
        .to have_content "A new message has been posted on #{site.name}:"
    end

    it 'has message in body' do
      expect(subject.body).to have_content message.name
      expect(subject.body).to have_content message.email
      expect(subject.body).to have_content message.phone
      expect(subject.body).to have_content message.message
    end
  end

  describe '.user_added_to_site' do
    subject { described_class.user_added_to_site(user, site, site_user) }

    include_examples 'site email'

    it 'is sent to users email' do
      expect(subject.to).to eq [user.email]
    end

    it 'has subject' do
      expect(subject.subject).to eq 'Added to site'
    end

    it 'has users name' do
      expect(subject.body).to have_content "Hi #{user.name}"
    end

    it 'has text in body' do
      expect(subject.body).to have_content(
        "You have been added to #{site.name} site by #{site_user.name}."
      )
    end
  end
end
