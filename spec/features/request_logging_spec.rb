require 'rails_helper'

RSpec.describe 'request logging', type: :feature do
  let(:events) { [] }
  let(:new_id) { Digest::MD5.hexdigest(rand.to_s) }

  before do
    ActiveSupport::Notifications
      .subscribe('process_action.action_controller') do |*args|
      events << ActiveSupport::Notifications::Event.new(*args)
    end

    page.driver.header('User-Agent', new_company_name)
    page.driver.header('X-Request-Id', new_id)
    visit_page '/home'

    expect(events.size).to eq 1
  end

  it 'logs default information' do
    expect(events.first.payload[:controller]).to eq 'PagesController'
  end

  it 'logs extra information' do
    expect(events.first.payload[:host]).to eq 'localhost'
    expect(events.first.payload[:remote_ip]).to eq '127.0.0.1'
    expect(events.first.payload[:request_id]).to eq new_id
    expect(events.first.payload[:user_agent]).to eq new_company_name
    expect(events.first.payload[:user_id]).to be_nil
  end

  it 'uses extra information in lograge' do
    result = Rails.application.config.lograge.custom_options.call(events.first)

    expect(result).to eq(
      host: 'localhost',
      remote_ip: '127.0.0.1',
      request_id: new_id,
      user_agent: "\"#{new_company_name}\""
    )
  end

  it_behaves_like 'logged in user' do
    it 'logs user_id' do
      expect(events.last.payload[:user_id]).to eq user.id

      result = Rails.application.config.lograge.custom_options.call(events.last)
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
