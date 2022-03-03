require 'rails_helper'

RSpec.describe Types::QueryType do
  subject(:result) { GraphqlSchema.execute(query, context:) }

  let(:site) { create(:site) }
  let(:user) { build(:user, site:) }
  let(:context) { { user:, site: } }

  context 'with images query' do
    let!(:image1) { create(:image, name: 'Image 1', site:) }
    let!(:image2) { create(:image, name: 'Image 2', site:) }

    let(:query) do
      <<~BODY
        query {
          images {
            nodes {
              name
            }
            totalCount
          }
        }
      BODY
    end

    let(:expected_result) do
      [
        {
          'images' => {
            'nodes' => [
              { 'name' => image1.name },
              { 'name' => image2.name }
            ],
            'totalCount' => 2
          }
        }
      ]
    end

    before { create(:image) }

    it 'returns ordered images' do
      expect(result.values).to eq expected_result
    end
  end

  context 'with messages query' do
    let!(:message1) do
      create(
        :message,
        name: 'Message 1',
        site:,
        created_at: 2.days.ago,
        updated_at: 2.days.ago
      )
    end

    let!(:message2) do
      create(
        :message,
        site:,
        name: 'Message 2',
        created_at: 1.day.ago,
        updated_at: 1.day.ago
      )
    end

    let(:query) do
      <<~BODY
        query {
          messages(orderBy: {field: CREATED_AT, direction: DESC}) {
            nodes {
              name
            }
            totalCount
          }
        }
      BODY
    end

    let(:expected_result) do
      [
        {
          'messages' => {
            'nodes' => [
              { 'name' => message2.name },
              { 'name' => message1.name }
            ],
            'totalCount' => 2
          }
        }
      ]
    end

    before { create(:message) }

    it 'returns scoped ordered messages' do
      expect(result.values).to eq expected_result
    end
  end

  context 'with pages query' do
    let!(:page1) { create(:page, name: 'Page 1', site:) }
    let!(:page2) { create(:page, name: 'Page 2', site:) }

    let(:query) do
      <<~BODY
        query {
          pages {
            nodes {
              name
            }
            totalCount
          }
        }
      BODY
    end

    let(:expected_result) do
      [
        {
          'pages' => {
            'nodes' => [
              { 'name' => page1.name },
              { 'name' => page2.name }
            ],
            'totalCount' => 2
          }
        }
      ]
    end

    before { create(:page) }

    it 'returns ordered pages' do
      expect(result.values).to eq expected_result
    end
  end

  context 'with sites query' do
    let!(:site2) do
      create(
        :site,
        host: 'aaaa.com',
        created_at: 2.days.ago,
        updated_at: 2.days.ago
      )
    end

    let(:user) { build(:user, groups: [site.host, site2.host]) }

    let(:query) do
      <<~BODY
        query {
          sites {
            nodes {
              host
            }
            totalCount
          }
        }
      BODY
    end

    let(:expected_result) do
      [
        {
          'sites' => {
            'nodes' => [
              { 'host' => site2.host },
              { 'host' => site.host }
            ],
            'totalCount' => 2
          }
        }
      ]
    end

    before { create(:site) }

    it 'returns ordered sites' do
      expect(result.values).to eq expected_result
    end
  end

  context 'with node query' do
    let(:message) { create(:message, site:) }

    let(:id) { Base64.urlsafe_encode64("Message-#{message.id}") }

    let(:query) do
      <<~BODY
        query {
          node(id: "#{id}") {
            id
            ... on Message {
              name
            }
          }
        }
      BODY
    end

    let(:expected_result) do
      [
        {
          'node' => {
            'id' => id,
            'name' => message.name
          }
        }
      ]
    end

    it 'returns message' do
      expect(result.values).to eq expected_result
    end
  end
end
