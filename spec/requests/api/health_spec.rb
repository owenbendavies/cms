require 'rails_helper'

RSpec.describe 'GET /api/health' do
  it 'renders ok' do
    request_page

    expect(json_body).to eq('status' => 'ok')
  end
end
