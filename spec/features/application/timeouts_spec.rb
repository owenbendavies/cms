require 'rails_helper'

RSpec.feature 'Timeouts' do
  scenario 'visiting a quick page' do
    visit '/timeout?seconds=1'
    expect(page).to have_content 'ok'
  end

  scenario 'visiting a slow page' do
    expect { visit '/timeout?seconds=3.5' }
      .to raise_error Rack::Timeout::RequestTimeoutError
  end
end
