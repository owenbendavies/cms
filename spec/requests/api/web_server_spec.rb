require 'rails_helper'

RSpec.describe 'API application web server' do
  include_context 'with headers'

  context 'when api page like GET /api/system/health' do
    include_examples 'sets headers' do
      let(:expected_content_type) { 'application/json' }
    end
  end
end
