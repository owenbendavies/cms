require 'rails_helper'

RSpec.describe 'GET /:id/edit' do
  let(:page) { FactoryBot.create(:page, site: site) }
  let(:request_path_id) { page.url }

  include_examples 'authenticated page'
end
