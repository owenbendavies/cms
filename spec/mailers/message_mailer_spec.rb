require 'rails_helper'

RSpec.describe MessageMailer do
  describe '.new_message' do
    let!(:site) { FactoryGirl.create(:site) }
    let!(:message) { FactoryGirl.create(:message, site: site) }
    let!(:user) { site.users.first }

    it 'sends a message' do
      expect {
        described_class.new_message(message).deliver_now
      }.to change {ActionMailer::Base.deliveries.size}.by(1)
    end

    it 'has from address as site email' do
      described_class.new_message(message).deliver_now
      subject = ActionMailer::Base.deliveries.last

      expect(subject.from).to eq [site.email]
    end

    it 'is sent to sites user email' do
      described_class.new_message(message).deliver_now
      subject = ActionMailer::Base.deliveries.last

      expect(subject.to).to eq site.users.map(&:email).sort
    end

    it 'includes message subject' do
      described_class.new_message(message).deliver_now
      subject = ActionMailer::Base.deliveries.last

      expect(subject.subject).to eq message.subject
    end

    it 'has a message body' do
      described_class.new_message(message).deliver_now
      subject = ActionMailer::Base.deliveries.last
      body = subject.body

      expect(body).to include "Name: #{message.name}"
      expect(body).to include "Email: #{message.email}"
      expect(body).to include "Phone: #{message.phone}"
      expect(body).to include "Message: #{message.message}"
    end
  end
end
