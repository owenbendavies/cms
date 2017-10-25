require 'rails_helper'

RSpec.describe 'PUT /:id' do
  let(:page) { FactoryBot.create(:page, site: site) }
  let(:request_path_id) { page.url }
  let(:request_params) { { page: { name: new_name } } }
  let(:expected_status) { 302 }

  include_examples 'authenticated page'
end
