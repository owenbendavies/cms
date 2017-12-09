require 'rails_helper'

RSpec.describe 'Errors' do
  context 'with GET /system/error_500' do
    let(:user) { FactoryBot.create(:user, :sysadmin) }

    it 'raises 500 error' do
      expect { request_page }.to raise_error(RuntimeError, 'Test 500 error')
    end
  end

  context 'with GET /system/error_delayed' do
    let(:user) { FactoryBot.create(:user, :sysadmin) }

    after { Delayed::Job.last.destroy! }

    it 'renders message' do
      request_page

      expect(body).to eq 'Delayed error sent'
    end

    it 'creates delayed job' do
      request_page

      expect(Delayed::Job.count).to eq 1
    end

    it 'raises error for delayed job' do
      request_page

      expect { Delayed::Job.last.invoke_job }.to raise_error(RuntimeError, 'Test delayed error')
    end
  end

  context 'with GET /system/error_timeout' do
    let(:user) { FactoryBot.create(:user, :sysadmin) }

    it 'raises timeout error' do
      expect { request_page }.to raise_error Rack::Timeout::RequestTimeoutError
    end
  end
end
