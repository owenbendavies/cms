require 'rails_helper'

RSpec.describe 'Logging' do
  let(:request_method) { :get }
  let(:request_path) { '/sitemap?name=value&password=hidden' }

  let(:cf_ray) { '230b030023ae2822-SJC' }
  let(:country) { 'US' }
  let(:request_id) { SecureRandom.uuid }
  let(:user_agent) { new_company_name }

  let(:request_headers) do
    {
      'CF-IPCountry' => country,
      'CF-RAY' => cf_ray,
      'User-Agent' => user_agent,
      'X-Request-Id' => request_id
    }
  end

  let(:events) { [] }

  let(:last_event) { JSON.parse(events.last) }

  let(:expected_result) do
    {
      '@timestamp' => match(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z\z/),
      '@version' => '1',
      'action' => 'index',
      'cf_ray' => cf_ray,
      'controller' => 'pages',
      'country' => 'US',
      'db' => an_instance_of(Float),
      'duration' => an_instance_of(Float),
      'format' => 'html',
      'fwd' => '127.0.0.1',
      'host' => request_host,
      'method' => 'GET',
      'parameters' => { 'name' => 'value', 'password' => '[FILTERED]' },
      'path' => '/sitemap',
      'request_id' => request_id,
      'route' => 'pages#index',
      'source' => 'unknown',
      'status' => 200,
      'tags' => ['request'],
      'user_agent' => user_agent,
      'user_id' => user_id,
      'view' => an_instance_of(Float)
    }
  end

  before do
    allow(LogStasher.logger).to receive(:<<) do |message|
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
