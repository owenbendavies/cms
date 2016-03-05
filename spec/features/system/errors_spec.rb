require 'rails_helper'

RSpec.feature 'Errors' do
  context 'error_500' do
    let(:go_to_url) { '/system/error_500' }

    authenticated_page login_user: :sysadmin do
      scenario 'visiting the page' do
        expect { unchecked_visit go_to_url }.to raise_error(RuntimeError, 'Test 500 error')
      end
    end
  end

  context 'error_delayed' do
    let(:go_to_url) { '/system/error_delayed' }

    authenticated_page login_user: :sysadmin do
      scenario 'visiting the page' do
        visit_200_page

        expect(page).to have_content 'Delayed error sent'

        delayed_jobs = Delayed::Job.all
        expect(delayed_jobs.count).to eq 1

        expect { delayed_jobs.last.invoke_job }.to raise_error(RuntimeError, 'Test delayed error')
      end
    end
  end

  context 'error_timeout' do
    let(:go_to_url) { '/system/error_timeout' }

    authenticated_page login_user: :sysadmin do
      scenario 'visiting the page' do
        expect { unchecked_visit go_to_url }.to raise_error Rack::Timeout::RequestTimeoutError
      end
    end
  end
end
