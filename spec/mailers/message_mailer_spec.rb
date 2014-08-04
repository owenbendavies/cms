require 'spec_helper'

describe MessageMailer do
  include_context 'new_fields'

  describe '.new_message' do
    let(:site) { FactoryGirl.build(:site) }
    let(:message) { FactoryGirl.build(:message, site: site) }

    before do
      @account = FactoryGirl.create(:account)
    end

    it 'sends a message' do
      expect {
        MessageMailer.new_message(message).deliver
      }.to change{ActionMailer::Base.deliveries.size}.by(1)
    end

    describe 'from address' do
      context 'site without www in host' do
        it 'has from address of site' do
          MessageMailer.new_message(message).deliver
          subject = ActionMailer::Base.deliveries.last

          expect(subject.header["From"].to_s.gsub('"', '')).
            to eq "#{site.name} <noreply@#{site.host}>"
        end
      end

      context 'site with www in host' do
        it 'removes the www' do
          site = FactoryGirl.build(:site, host: 'www.example.com')
          message = FactoryGirl.build(:message, site: site)
          FactoryGirl.create(:account, sites: ['www.example.com'])
          MessageMailer.new_message(message).deliver
          subject = ActionMailer::Base.deliveries.last

          expect(subject.header["From"].to_s.gsub('"', '')).
            to eq "#{site.name} <noreply@example.com>"
        end
      end
    end

    it 'is sent to account email address' do
      MessageMailer.new_message(message).deliver
      subject = ActionMailer::Base.deliveries.last

      expect(subject.to).to eq [@account.email]
    end

    it 'includes message subject' do
      MessageMailer.new_message(message).deliver
      subject = ActionMailer::Base.deliveries.last

      expect(subject.subject).to eq message.subject
    end

    it 'has a message body' do
      MessageMailer.new_message(message).deliver
      subject = ActionMailer::Base.deliveries.last
      body = subject.body

      expect(body).to include "Name: #{message.name}"
      expect(body).to include "Email address: #{message.email_address}"
      expect(body).to include "Phone number: #{message.phone_number}"
      expect(body).to include "Message: #{message.message}"
    end
  end
end
