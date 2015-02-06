require 'rails_helper'

RSpec.describe MessageMailer, type: :feature do
  describe '.new_message' do
    let!(:site) { FactoryGirl.create(:site) }
    let!(:message) { FactoryGirl.create(:message, site: site) }
    let!(:user) { site.users.first }

    subject { described_class.new_message(message) }

    it 'has from address as site email' do
      expect(subject.from).to eq [site.email]
    end

    it 'has from name as site name' do
      addresses = subject.header['from'].address_list.addresses
      expect(addresses.first.display_name).to eq site.name
    end

    it 'is sent to sites user email' do
      expect(subject.to).to eq site.users.map(&:email).sort
    end

    it 'includes message subject' do
      expect(subject.subject).to eq message.subject
    end

    describe 'body' do
      it 'has site name' do
        expect(subject.body).to have_content site.name
      end

      it 'has text' do
        expect(subject.body)
          .to have_content "A new message has been posted on #{site.name}:"
      end

      it 'has message' do
        expect(subject.body).to have_content "Name: #{message.name}"
        expect(subject.body).to have_content "Email: #{message.email}"
        expect(subject.body).to have_content "Phone: #{message.phone}"
        expect(subject.body).to have_content "Message: #{message.message}"
      end

      it 'has copyright in footer' do
        expect(subject.body)
          .to have_content "#{site.copyright} © #{Time.now.year}"
      end
    end
  end
end
