require 'rails_helper'

RSpec.describe 'Authorization' do
  context 'with an unauthorized user' do
    let(:request_user) { build(:user) }

    context 'when visiting a restricted page like GET /site/edit' do
      include_examples 'renders html page not found'
    end
  end
end
