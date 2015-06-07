require 'rails_helper'

RSpec.describe MessageMailer, type: :feature do
  describe '.new_message' do
    let(:site) { FactoryGirl.create(:site) }
    let(:message) { FactoryGirl.create(:message, site: site) }
    let(:user) { site.users.first }

    subject { described_class.new_message(message) }

    include_examples 'site email'

    it 'is sent to sites user email' do
      expect(subject.to).to eq site.users.map(&:email).sort
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
end
