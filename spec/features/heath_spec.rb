require 'spec_helper'

describe 'health' do
  it 'renders ok' do
    visit_page '/health'
    page.should have_content 'ok'
  end
end
