require 'spec_helper'

describe 'timeout' do
  include_context 'default_site'

  it 'does not raise error when no timeout is passed in' do
    visit '/timeout'
    expect(page).to have_content 'ok'
  end

  it 'does not raise an error when render less than 1 second' do
    visit '/timeout?seconds=1'
    expect(page).to have_content 'ok'
  end

  it 'raises error when render is more than 1 second' do
    expect {
      visit '/timeout?seconds=3.5'
    }.to raise_error Rack::Timeout::RequestTimeoutError
  end
end
