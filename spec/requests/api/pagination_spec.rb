require 'rails_helper'

RSpec.describe 'API pagination' do
  include_context 'with headers'

  let(:request_method) { :get }
  let(:request_path) { '/api/messages' }

  let(:request_user) { FactoryBot.build(:user, site: site) }

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
        'X-Page' => '1',
        'X-Per-Page' => '10',
        'X-Total' => '12'
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

  context 'with per_page too large' do
    let(:request_path) { '/api/messages?per_page=101' }
    let(:expected_status) { 400 }

    let(:expected_body) do
      {
        'error' => 'Bad request',
        'message' => 'Invalid parameters',
        'errors' => {
          'per_page' => ['does not have a valid value']
        }
      }
    end

    it 'returns error' do
      request_page
      expect(json_body).to eq expected_body
    end
  end
end
