require 'rails_helper'

RSpec.feature 'Logging' do
  before do
    ActiveSupport::Notifications.subscribe('process_action.action_controller') do |*args|
      events << ActiveSupport::Notifications::Event.new(*args)
    end

    page.driver.header('User-Agent', new_company_name)
    page.driver.header('X-Request-Id', new_id)
  end

  let(:go_to_url) { '/home' }
  let(:events) { [] }
  let(:new_id) { Digest::MD5.hexdigest(rand.to_s) }
  let(:result) { Rails.application.config.lograge.custom_options.call(events.first) }

  scenario 'visiting a page' do
    visit_200_page go_to_url

    expect(events.size).to eq 1

    expect(result).to eq(
      host: 'localhost',
      request_id: new_id,
      fwd: '127.0.0.1',
      user_id: nil,
      user_agent: "\"#{new_company_name}\""
    )
  end

  as_a 'logged in user' do
    scenario 'visiting a page' do
      expect(events.size).to eq 1

      expect(result).to eq(
        host: 'localhost',
        request_id: new_id,
        fwd: '127.0.0.1',
        user_id: user.id,
        user_agent: "\"#{new_company_name}\""
      )
    end
  end
end
