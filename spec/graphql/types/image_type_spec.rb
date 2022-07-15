require 'rails_helper'

RSpec.describe Types::ImageType do
  subject(:result) { GraphqlSchema.execute(query, context:) }

  let(:site) { create(:site) }
  let(:user) { build(:user, site:) }
  let(:context) { { user:, site: } }

  let!(:image) { create(:image, site:) }

  let(:uuid) { File.basename(image.filename, '.jpg') }

  let(:query) do
    <<~BODY
      query {
        images {
          nodes {
            createdAt
            id
            name
            updatedAt
            url
            urlProcessed
            urlSpan3
            urlSpan4
            urlSpan8
            urlSpan12
            urlThumbnail
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
            {
              'createdAt' => image.created_at.iso8601,
              'id' => Base64.urlsafe_encode64("Image-#{image.id}"),
              'name' => image.name,
              'updatedAt' => image.updated_at.iso8601,
              'url' => File.join('http://localhost:3000', 'images', uuid, 'original.jpg'),
              'urlProcessed' => File.join('http://localhost:3000', 'images', uuid, 'processed.jpg'),
              'urlSpan3' => File.join('http://localhost:3000', 'images', uuid, 'span3.jpg'),
              'urlSpan4' => File.join('http://localhost:3000', 'images', uuid, 'span4.jpg'),
              'urlSpan8' => File.join('http://localhost:3000', 'images', uuid, 'span8.jpg'),
              'urlSpan12' => File.join('http://localhost:3000', 'images', uuid, 'span12.jpg'),
              'urlThumbnail' => File.join('http://localhost:3000', 'images', uuid, 'thumbnail.jpg')
            }
          ],
          'totalCount' => 1
        }
      }
    ]
  end

  it 'returns all fields' do
    expect(result.values).to eq expected_result
  end
end
