require 'rails_helper'

RSpec.describe 'API Logging' do
  let(:user) { FactoryBot.create(:user, site: site) }
  let(:message) { FactoryBot.create(:message, site: site) }

  let(:request_method) { :get }
  let(:request_path) { "/api/messages/#{message.uuid}" }

  let(:request_id) { SecureRandom.uuid }
  let(:user_agent) { new_company_name }

  let(:request_headers) do
    {
      'User-Agent' => user_agent,
      'X-Request-Id' => request_id
    }
  end

  let(:events) { [] }

  let(:expected_result) do
    /\Amethod=GET path=#{request_path} status=200 duration=[0-9]+\.[0-9][0-9] view=[0-9]+\.[0-9][0-9] db=[0-9]+\.[0-9][0-9] host=#{request_host} fwd=127.0.0.1 user_agent=#{user_agent}\z/ # rubocop:disable Metrics/LineLength
  end

  before do
    allow(Rails.logger).to receive(:info) do |message|
      events << message
    end
  end

  it 'logs request information' do
    request_page
    expect(events.last).to match(expected_result)
  end
end
