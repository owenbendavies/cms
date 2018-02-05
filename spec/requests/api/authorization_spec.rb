require 'rails_helper'

RSpec.describe 'API Authorization' do
  context 'with an unauthorized user' do
    let(:request_user) { FactoryBot.create(:user) }

    context 'when visiting a restricted page like GET /api/messages' do
      include_examples 'renders json forbidden'
    end
  end
end
