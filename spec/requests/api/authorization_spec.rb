require 'rails_helper'

RSpec.describe 'API Authorization' do
  context 'with an unauthorized user' do
    let(:user) { FactoryBot.create(:user) }

    context 'when visiting a restricted page like GET /api/messages/:id' do
      let(:message) { FactoryBot.create(:message) }
      let(:request_path_id) { message.uuid }

      include_examples 'renders json forbidden'
    end
  end
end
