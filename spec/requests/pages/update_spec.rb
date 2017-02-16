require 'rails_helper'

RSpec.describe 'PUT /:id' do
  let(:page) { FactoryGirl.create(:page, site: site) }
  let(:request_path_id) { page.url }
  let(:request_params) { { page: { name: new_name } } }
  let(:expected_status) { 302 }

  include_context 'authenticated page'
end
