require 'rails_helper'

RSpec.describe 'Unknown routes' do
  let(:request_method) { :get }
  let(:request_path) { '/sitemap' }

  context 'with root url' do
    let(:request_path) { '/' }
    let(:expected_status) { 301 }

    it 'redirects to home' do
      request_page

      expect(response).to redirect_to '/home'
    end
  end

  context 'with urls with .html in' do
    let(:request_path) { '/sitemap.html' }

    include_examples 'renders html page not found'
  end

  context 'with urls with dots in path' do
    let(:request_path) { '/file.pid/file' }

    include_examples 'renders html page not found'
  end

  context 'with unknown url' do
    let(:request_path) { '/bad/route' }

    include_examples 'renders html page not found'
  end

  context 'with missing record' do
    let(:request_path) { '/bad' }

    include_examples 'renders html page not found'
  end

  context 'with unknown site' do
    let(:request_host) { new_host }
    let(:expected_status) { 404 }

    it 'renders site not found' do
      request_page
      expect(body).to include 'Site Not Found'
    end
  end

  context 'with unknown site and unknown format' do
    let(:request_path) { '/sitemap.txt' }
    let(:request_host) { new_host }

    include_examples 'returns 406'
  end

  context 'with unknown extension' do
    let(:request_path) { '/sitemap.txt' }

    include_examples 'returns 406'
  end

  context 'with unknown accept header' do
    let(:request_headers) { { 'Accept' => 'application/json' } }

    include_examples 'returns 406'
  end

  context 'with non xhr js' do
    let(:request_headers) { { 'Accept' => 'text/javascript' } }
    let(:request_path) { '/bad/content/js' }

    include_examples 'returns 406'
  end
end
