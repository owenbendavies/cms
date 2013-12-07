require 'spec_helper'

describe 'request logging' do
  include_context 'default_site'

  let(:events) { [] }

  before do
    ActiveSupport::Notifications.
      subscribe('process_action.action_controller') do |*args|
      events << ActiveSupport::Notifications::Event.new(*args)
    end

    page.driver.browser.header('User-Agent', 'capybara')
    visit_page '/home'

    events.size.should eq 1
  end

  it 'logs default information' do
    events.first.payload[:controller].should eq 'PagesController'
  end

  it 'logs extra information' do
    events.first.payload[:host].should eq 'localhost'
    events.first.payload[:remote_ip].should eq '127.0.0.1'
    events.first.payload[:user_agent].should eq '"capybara"'
  end

  it 'uses extra information in lograge' do
    result = Cms::Application.config.lograge.custom_options.call(events.first)

    result.should eq ({
      host: 'localhost',
      remote_ip: '127.0.0.1',
      user_agent: '"capybara"',
    })
  end
end
