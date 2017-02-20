require 'rails_helper'

RSpec.describe 'GET /:id/edit' do
  let(:page) { FactoryGirl.create(:page, site: site) }
  let(:request_path_id) { page.url }

  include_context 'authenticated page'
end
