require 'rails_helper'

RSpec.feature 'Logging' do
  before do
    ActiveSupport::Notifications.subscribe(
      'process_action.action_controller'
    ) do |*args|
      events << ActiveSupport::Notifications::Event.new(*args)
    end

    page.driver.header('User-Agent', new_company_name)
    page.driver.header('X-Request-Id', new_id)
  end

  let(:go_to_url) { '/home' }
  let(:events) { [] }
  let(:new_id) { Digest::MD5.hexdigest(rand.to_s) }

  let(:result) do
    Rails.application.config.lograge.custom_options.call(events.first)
  end

  it_behaves_like 'non logged in user' do
    scenario 'visiting a page' do
      expect(events.size).to eq 1

      expect(result).to eq(
        host: 'localhost',
        remote_ip: '127.0.0.1',
        request_id: new_id,
        user_agent: "\"#{new_company_name}\"",
        user_id: nil
      )
    end
  end

  it_behaves_like 'logged in user' do
    scenario 'visiting a page' do
      expect(events.size).to eq 1

      expect(result).to eq(
        host: 'localhost',
        remote_ip: '127.0.0.1',
        request_id: new_id,
        user_agent: "\"#{new_company_name}\"",
        user_id: user.id
      )
    end
  end
end
