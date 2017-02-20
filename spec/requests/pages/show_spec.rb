require 'rails_helper'

RSpec.describe 'GET /:id' do
  context 'private page' do
    let(:page) { FactoryGirl.create(:private_page, site: site) }
    let(:request_path_id) { page.url }

    include_context 'authenticated page'
  end

  context 'page from another site' do
    let(:page) { FactoryGirl.create(:page) }
    let(:request_path_id) { page.url }

    include_context 'renders page not found'
  end
end
