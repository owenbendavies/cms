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

  let(:expected_result) do
    /\Amethod=GET path=#{request_path} format=html controller=PagesController action=index status=200 duration=[0-9]+\.[0-9][0-9] view=[0-9]+\.[0-9][0-9] db=[0-9]+\.[0-9][0-9] host=#{request_host} request_id=#{request_id} fwd=127.0.0.1 user_id=#{user_id} user_agent=#{user_agent}\z/ # rubocop:disable Metrics/LineLength
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
      expect(events.last).to match(expected_result)
    end
  end

  context 'with user' do
    let(:user) { FactoryBot.create(:user) }
    let(:user_id) { user.id }

    it 'logs request information and the user id' do
      request_page
      expect(events.last).to match(expected_result)
    end
  end
end
