require 'rails_helper'

RSpec.describe MessageMailer do
  describe '.new_message' do
    let!(:site) { FactoryGirl.create(:site) }
    let!(:message) { FactoryGirl.create(:message, site: site) }
    let!(:account) { site.accounts.first }

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
          site.host = 'www.example.com'
          site.save!

          MessageMailer.new_message(message).deliver
          subject = ActionMailer::Base.deliveries.last

          expect(subject.header["From"].to_s.gsub('"', '')).
            to eq "#{site.name} <noreply@example.com>"
        end
      end
    end

    it 'is sent to sites account email' do
      MessageMailer.new_message(message).deliver
      subject = ActionMailer::Base.deliveries.last

      expect(subject.to).to eq site.accounts.map(&:email).sort
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
      expect(body).to include "Email: #{message.email}"
      expect(body).to include "Phone: #{message.phone}"
      expect(body).to include "Message: #{message.message}"
    end
  end
end
