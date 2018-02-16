require 'rails_helper'

RSpec.describe 'GET /api/health' do
  let(:request_host) { new_host }

  include_examples(
    'swagger documentation',
    description: 'Returns the health of the system',
    model: 'SystemHealth'
  )

  it 'renders ok' do
    request_page

    expect(json_body).to eq('status' => 'ok')
  end
end
