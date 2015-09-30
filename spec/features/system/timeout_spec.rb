require 'rails_helper'

RSpec.feature 'Timeouts' do
  let(:go_to_url) { '/system/timeout?seconds=1' }

  include_examples 'restricted page'

  as_a 'logged in admin' do
    scenario 'visiting a quick page' do
      visit_200_page '/system/timeout?seconds=1'
      expect(page).to have_content 'ok'
    end

    scenario 'visiting a slow page' do
      expect { visit_200_page '/system/timeout?seconds=3.5' }
        .to raise_error Rack::Timeout::RequestTimeoutError
    end
  end
end
