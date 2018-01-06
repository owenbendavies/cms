require 'rails_helper'

RSpec.describe 'Errors' do
  let(:user) { FactoryBot.create(:user, :sysadmin) }

  context 'with GET /system/error_500' do
    it 'raises 500 error' do
      expect { request_page }.to raise_error(RuntimeError, 'Test 500 error')
    end
  end

  context 'with GET /system/error_timeout' do
    it 'raises timeout error' do
      expect { request_page }.to raise_error Rack::Timeout::RequestTimeoutError
    end
  end
end
