require 'rails_helper'

RSpec.feature 'Errors' do
  context 'error_500' do
    let(:go_to_url) { '/system/error_500' }

    include_examples 'restricted page'

    scenario 'as a logged in admin visiting the page' do
      safe_login_as admin
      expect { visit_page go_to_url }.to raise_error(RuntimeError, 'Test 500 error')
    end
  end

  context 'error_delayed' do
    let(:go_to_url) { '/system/error_delayed' }

    include_examples 'restricted page'

    as_a 'logged in admin' do
      scenario 'visiting the page' do
        expect(page).to have_content 'Delayed error sent'

        delayed_jobs = Delayed::Job.all
        expect(delayed_jobs.count).to eq 1

        expect { delayed_jobs.last.invoke_job }.to raise_error(RuntimeError, 'Test delayed error')
      end
    end
  end

  context 'error_timeout' do
    let(:go_to_url) { '/system/error_timeout?seconds=0.5' }

    include_examples 'restricted page'

    as_a 'logged in admin' do
      scenario 'visiting a quick page' do
        visit_200_page '/system/error_timeout?seconds=0.5'
        expect(page).to have_content 'ok'
      end

      scenario 'visiting a slow page' do
        expect { visit_page '/system/error_timeout?seconds=2.5' }
          .to raise_error Rack::Timeout::RequestTimeoutError
      end
    end
  end
end
