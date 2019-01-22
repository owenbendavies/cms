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
    {
      action: 'index',
      controller: 'PagesController',
      db_runtime: an_instance_of(Float),
      format: :html,
      fwd: '127.0.0.1',
      host: request_host,
      ip: '127.0.0.1',
      method: 'GET',
      params: { 'action' => 'index', 'controller' => 'pages' },
      path: request_path,
      request_id: request_id,
      route: 'pages#index',
      status: 200,
      user_agent: user_agent,
      user_id: user_id,
      view_runtime: an_instance_of(Float)
    }
  end

  before do
    ActiveSupport::Notifications.subscribe(
      'process_action.action_controller'
    ) do |_, _, _, _, payload|
      events << payload
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
    let(:request_user) { FactoryBot.build(:user) }
    let(:user_id) { request_user.id }

    it 'logs request information and the user id' do
      request_page
      expect(events.last).to match(expected_result)
    end
  end
end
