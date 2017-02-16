require 'rails_helper'

RSpec.describe 'GET /site/messages/:id' do
  let(:message) { FactoryGirl.create(:message, site: site) }
  let(:request_path_id) { message.uuid }

  include_context 'authenticated page'
end
