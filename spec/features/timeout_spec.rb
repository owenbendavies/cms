require 'spec_helper'

describe 'timeout' do
  include_context 'default_site'

  it 'does not raise an error when render less than 1 second' do
    visit '/timeout?seconds=0.5'
    page.should have_content 'ok'
  end

  it 'raises error when render is more than 1 second' do
    expect {
      visit '/timeout?seconds=2'
    }.to raise_error Timeout::Error
  end
end
