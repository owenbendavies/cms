require 'rails_helper'

RSpec.describe 'GET /site/messages/:id' do
  let(:message) { FactoryBot.create(:message, site: site) }
  let(:request_path_id) { message.uuid }

  include_examples 'authenticated page'
end
