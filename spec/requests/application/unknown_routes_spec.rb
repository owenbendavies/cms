require 'rails_helper'

RSpec.describe 'Application unknown routes' do
  shared_context 'renders page not found 404' do
    it 'renders page not found 404' do
      request_page(expected_status: 404)
      expect(body).to include 'Page Not Found'
    end
  end

  shared_context 'returns 406' do
    it 'returns 406' do
      request_page(expected_status: 406)
      expect(body).to be_empty
    end
  end

  context 'root url' do
    let(:request_path) { '/' }

    it 'redirects to home' do
      request_page(expected_status: 302)

      expect(response).to redirect_to '/home'
    end
  end

  context 'urls with .html in' do
    let(:request_path) { '/login.html' }

    include_context 'renders page not found 404'
  end

  context 'urls with dots in path' do
    let(:request_path) { '/file.pid/file' }

    include_context 'renders page not found 404'
  end

  context 'unknown url' do
    let(:request_path) { '/badroute' }

    include_context 'renders page not found 404'
  end

  context 'unknown site' do
    let(:request_host) { new_host }

    it 'renders site not found 404' do
      request_page(expected_status: 404)
      expect(body).to include 'Site Not Found'
    end
  end

  context 'unknown site and unkown format' do
    let(:request_path) { '/login.txt' }
    let(:request_host) { new_host }

    include_context 'returns 406'
  end

  context 'unkown format' do
    let(:request_path) { '/login.txt' }

    include_context 'returns 406'
  end

  context 'unknown accept header' do
    let(:request_headers) { { 'Accept' => 'application/json' } }

    include_context 'returns 406'
  end
end
