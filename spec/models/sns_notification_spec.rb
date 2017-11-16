# == Schema Information
#
# Table name: sns_notifications
#
#  id         :integer          not null, primary key
#  message    :json             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe SnsNotification do
  describe '#from_message' do
    subject(:sns_notification) { described_class.from_message(message.to_json) }

    let(:message_file) { 'subscription_confirmation.json' }
    let(:message_contents) { Rails.root.join('spec', 'assets', 'sns', message_file).read }
    let(:message_json) { JSON.parse(message_contents) }
    let(:message) { message_json }
    let(:verifier) { instance_double(Aws::SNS::MessageVerifier) }

    before do
      expect(Aws::SNS::MessageVerifier).to receive(:new).and_return(verifier)
    end

    context 'without message type' do
      before do
        expect(verifier).to receive(:authenticate!).with(message.to_json)
      end

      let(:message) { message_json.tap { |json| json.delete 'Type' } }

      it 'raises execption' do
        expect { sns_notification }.to raise_error(KeyError, 'key not found: "Type"')
      end
    end

    context 'with ubscription confirmation message' do
      before do
        expect(verifier).to receive(:authenticate!).with(message.to_json)

        topic = instance_double(Aws::SNS::Topic)

        expect(topic).to receive(:confirm_subscription).with(token: message.fetch('Token'))

        expect(Aws::SNS::Topic).to receive(:new).with(
          arn: message.fetch('TopicArn'),
          client: AWS_SNS_CLIENT
        ).and_return topic
      end

      it 'confirms the subscription' do
        sns_notification
      end
    end

    context 'with notification' do
      before do
        expect(verifier).to receive(:authenticate!).with(message.to_json)
      end

      let(:message_file) { 'notification.json' }

      it 'saves the notification' do
        expect { sns_notification }.to change(described_class, :count).by(1)
      end

      it 'saves the message' do
        sns_notification
        expect(described_class.last.message).to eq message
      end
    end

    context 'with unverified message' do
      before do
        expect(verifier).to receive(:authenticate!)
          .and_raise(Aws::SNS::MessageVerifier::VerificationError)
      end

      it 'raises a verification error' do
        expect { sns_notification }.to raise_error(Aws::SNS::MessageVerifier::VerificationError)
      end
    end
  end
end
