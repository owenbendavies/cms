require 'rails_helper'

RSpec.describe 'DELETE /:id' do
  let(:page) { FactoryBot.create(:page, site: site) }
  let(:request_path_id) { page.url }
  let(:expected_status) { 302 }

  include_examples 'authenticated page'
end
