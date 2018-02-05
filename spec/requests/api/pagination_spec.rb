require 'rails_helper'

RSpec.describe 'API pagination' do
  include_context 'with headers'

  let(:request_method) { :get }
  let(:request_path) { '/api/messages' }

  let(:user) { FactoryBot.create(:user, site: site) }

  let!(:objects) do
    (0..11).map do |i|
      FactoryBot.create(
        :message,
        site: site,
        created_at: Time.zone.now - 1.month - 3.days - i.minutes,
        updated_at: Time.zone.now - 1.month - 3.days - i.minutes
      )
    end
  end

  let(:uids) { json_body.map { |result| result.fetch('uid') } }

  context 'with no parameters' do
    let(:expected_url) { "http://#{site.host}/api/messages" }

    let(:expected_pagination_headers) do
      expected_non_random_headers.merge(
        'Link' => "<#{expected_url}?page=2>; rel=\"last\", <#{expected_url}?page=2>; rel=\"next\"",
        'Per-Page' => '10',
        'Total' => '12'
      )
    end

    let(:expected_content_type) { 'application/json' }

    it 'returns first 10 objects' do
      request_page
      expect(uids).to eq objects[0, 10].map(&:uid)
    end

    it 'sets pagination headers' do
      request_page
      expect(non_random_headers).to eq expected_pagination_headers
    end
  end

  context 'with page' do
    let(:request_path) { '/api/messages?page=2' }

    it 'returns specified page' do
      request_page
      expect(uids).to eq objects[10, 2].map(&:uid)
    end
  end

  context 'with per_page' do
    let(:request_path) { '/api/messages?per_page=5' }

    it 'returns specified number of objects' do
      request_page
      expect(uids).to eq objects[0, 5].map(&:uid)
    end
  end

  context 'with invalid parameters' do
    let(:request_path) { '/api/messages?per_page=bad' }

    let(:expected_body) do
      {
        'http_status_code' => 400,
        'error' => 'Bad Request',
        'messages' => [
          'per_page is invalid'
        ]
      }
    end

    it 'returns errors' do
      request_page(expected_status: 400)
      expect(json_body).to eq expected_body
    end
  end
end
