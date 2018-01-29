require 'rails_helper'

RSpec.describe 'API Unknown routes' do
  let(:request_method) { :get }

  context 'with root url' do
    let(:request_path) { '/api' }

    include_examples 'renders json page not found'
  end

  context 'with unknown url' do
    let(:request_path) { '/api/badroute.json' }

    include_examples 'renders json page not found'
  end

  context 'with missing record' do
    let(:request_path) { '/api/messages/badmessage' }

    include_examples 'renders json forbidden'
  end

  context 'with unkown extension' do
    let(:request_path) { '/api/messages/id.txt' }

    include_examples 'renders json page not found'
  end
end
