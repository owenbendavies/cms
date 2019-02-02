require 'rails_helper'

RSpec.describe LogStashLogger do
  let(:logger) { described_class.new(type: :stdout) }
  let(:events) { [] }
  let(:last_event) { JSON.parse(events.last) }

  let(:expected_result) do
    {
      '@timestamp' => match(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}\+\d{2}:\d{2}\z/),
      '@version' => '1',
      'fwd' => ip_address,
      'host' => host,
      'message' => new_message,
      'request_id' => request_id,
      'severity' => 'INFO',
      'tags' => ['rails']
    }
  end

  before do
    allow($stdout).to receive(:write) do |event|
      events << event
    end
  end

  context 'without tags' do
    let(:ip_address) { nil }
    let(:request_id) { nil }
    let(:host) { nil }

    it 'logs the message' do
      logger.info(new_message)

      expect(last_event).to match(expected_result)
    end
  end

  context 'with tags' do
    let(:ip_address) { Faker::Internet.ip_v4_address }
    let(:request_id) { SecureRandom.uuid }
    let(:host) { new_host }

    it 'logs the tags' do
      logger.tagged(new_host, ip_address, request_id) do
        logger.info(new_message)
      end

      expect(last_event).to match(expected_result)
    end
  end
end
