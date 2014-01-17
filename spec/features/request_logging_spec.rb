require 'spec_helper'

describe 'request logging' do
  include_context 'default_site'
  include_context 'new_fields'

  let(:events) { [] }

  before do
    ActiveSupport::Notifications.
      subscribe('process_action.action_controller') do |*args|
      events << ActiveSupport::Notifications::Event.new(*args)
    end

    page.driver.browser.header('User-Agent', new_company_name)
    page.driver.browser.header('X-Request-Id', new_id)
    visit_page '/home'

    events.size.should eq 1
  end

  it 'logs default information' do
    events.first.payload[:controller].should eq 'PagesController'
  end

  it 'logs extra information' do
    events.first.payload[:host].should eq 'localhost'
    events.first.payload[:remote_ip].should eq '127.0.0.1'
    events.first.payload[:request_id].should eq new_id
    events.first.payload[:user_agent].should eq new_company_name
    events.first.payload[:account_id].should be_nil
  end

  it 'uses extra information in lograge' do
    result = Cms::Application.config.lograge.custom_options.call(events.first)

    result.should eq ({
      host: 'localhost',
      remote_ip: '127.0.0.1',
      request_id: new_id,
      user_agent: "\"#{new_company_name}\"",
    })
  end

  it_behaves_like 'logged in account' do
    it 'logs account_id' do
      events.last.payload[:account_id].should eq @account.id

      result = Cms::Application.config.lograge.custom_options.call(events.last)
      result.should eq ({
        host: 'localhost',
        remote_ip: '127.0.0.1',
        request_id: new_id,
        user_agent: "\"#{new_company_name}\"",
        account_id: @account.id,
      })
    end
  end
end
