require 'spec_helper'

describe MessageMailer do
  include_context 'new_fields'

  describe '.new_message' do
    let(:site) { FactoryGirl.build(:site) }
    let(:message) { FactoryGirl.build(:message, site: site) }

    before do
      @account = FactoryGirl.create(:account)

      expect {
        MessageMailer.new_message(message).deliver
      }.to change{ActionMailer::Base.deliveries.size}.by(1)
    end

    subject { ActionMailer::Base.deliveries.last }

    it 'has from address of site' do
      expect(subject.header["From"].to_s.gsub('"', '')).
        to eq "#{site.name} <noreply@#{site.host}>"
    end

    it 'is sent to account email address' do
      expect(subject.to).to eq [@account.email]
    end

    it 'includes message subject' do
      expect(subject.subject).to eq message.subject
    end

    it 'has a message body' do
      body = subject.body

      expect(body).to include "Name: #{message.name}"
      expect(body).to include "Email address: #{message.email_address}"
      expect(body).to include "Phone number: #{message.phone_number}"
      expect(body).to include "Message: #{message.message}"
    end
  end

  describe 'site with www host' do
    let(:site) { FactoryGirl.build(:site, host: 'www.example.com') }
    let(:message) { FactoryGirl.build(:message, site: site) }

    before do
      @account = FactoryGirl.create(:account, sites: ['www.example.com'])

      expect {
        MessageMailer.new_message(message).deliver
      }.to change{ActionMailer::Base.deliveries.size}.by(1)
    end

    subject { ActionMailer::Base.deliveries.last }

    it 'should remove www from email' do
      expect(subject.header["From"].to_s.gsub('"', '')).
        to eq "#{site.name} <noreply@example.com>"
    end
  end
end
