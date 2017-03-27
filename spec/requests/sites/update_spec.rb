require 'rails_helper'

RSpec.describe 'PUT /site' do
  let(:request_params) { { site: { name: new_name } } }
  let(:expected_status) { 302 }

  include_examples 'authenticated page'
end
