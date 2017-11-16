require 'rails_helper'

RSpec.describe 'GET /:id' do
  context 'with private page' do
    let(:page) { FactoryBot.create(:page, :private, site: site) }
    let(:request_path_id) { page.url }

    include_examples 'authenticated page'
  end

  context 'with page from another site' do
    let(:page) { FactoryBot.create(:page) }
    let(:request_path_id) { page.url }

    include_examples 'renders page not found'
  end
end
