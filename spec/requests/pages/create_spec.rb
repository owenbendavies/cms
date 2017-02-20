require 'rails_helper'

RSpec.describe 'POST /' do
  let(:request_params) { { page: { name: 'New Page' } } }
  let(:expected_status) { 302 }

  include_context 'authenticated page'
end
