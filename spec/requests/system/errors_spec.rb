require 'rails_helper'

RSpec.describe 'Errors' do
  context 'GET /system/error_500' do
    include_context 'authenticated page', :skip_authorized_check

    context 'as a authorized user' do
      let(:user) { FactoryGirl.create(:sysadmin) }

      it 'raises 500 error' do
        expect { request_page }.to raise_error(RuntimeError, 'Test 500 error')
      end
    end
  end

  context 'GET /system/error_delayed' do
    include_context 'authenticated page', :skip_authorized_check

    context 'as a authorized user' do
      let(:user) { FactoryGirl.create(:sysadmin) }

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
  end

  context 'GET /system/error_timeout' do
    include_context 'authenticated page', :skip_authorized_check

    context 'as a authorized user' do
      let(:user) { FactoryGirl.create(:sysadmin) }

      it 'raises timeout error' do
        expect { request_page }.to raise_error Rack::Timeout::RequestTimeoutError
      end
    end
  end
end
