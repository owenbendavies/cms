require 'rails_helper'

RSpec.describe 'Logging' do
  let(:request_method) { :get }
  let(:request_path) { '/sitemap' }

  let(:request_id) { SecureRandom.uuid }
  let(:user_agent) { new_company_name }

  let(:request_headers) do
    {
      'User-Agent' => user_agent,
      'X-Request-Id' => request_id
    }
  end

  let(:events) { [] }
  let(:last_event) { JSON.parse(events.last) }

  let(:expected_result) do
    {
      'action' => 'index',
      'controller' => 'PagesController',
      'db' => an_instance_of(Float),
      'duration' => an_instance_of(Float),
      'format' => 'html',
      'fwd' => '127.0.0.1',
      'host' => request_host,
      'method' => 'GET',
      'path' => request_path,
      'request_id' => request_id,
      'status' => 200,
      'user_agent' => user_agent,
      'user_id' => user_id,
      'view' => an_instance_of(Float)
    }
  end

  before do
    allow(Rails.logger).to receive(:info) do |message|
      events << message
    end
  end

  context 'without user' do
    let(:user_id) { nil }

    it 'logs request information' do
      request_page
      expect(last_event).to match(expected_result)
    end
  end

  context 'with user' do
    let(:request_user) { FactoryBot.build(:user) }
    let(:user_id) { request_user.id }

    it 'logs request information and the user id' do
      request_page
      expect(last_event).to match(expected_result)
    end
  end
end
