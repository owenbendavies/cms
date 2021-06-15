require 'rails_helper'

RSpec.describe Types::ImageType do
  subject(:result) { GraphqlSchema.execute(query, context: context) }

  let(:site) { FactoryBot.create(:site) }
  let(:user) { FactoryBot.build(:user, site: site) }
  let(:context) { { user: user, site: site } }

  let!(:image) { FactoryBot.create(:image, site: site) }

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
              'url' => File.join(ENV.fetch('AWS_S3_ASSET_HOST'), 'images', uuid, 'original.jpg'),
              'urlProcessed' => File.join(ENV.fetch('AWS_S3_ASSET_HOST'), 'images', uuid, 'processed.jpg'),
              'urlSpan3' => File.join(ENV.fetch('AWS_S3_ASSET_HOST'), 'images', uuid, 'span3.jpg'),
              'urlSpan4' => File.join(ENV.fetch('AWS_S3_ASSET_HOST'), 'images', uuid, 'span4.jpg'),
              'urlSpan8' => File.join(ENV.fetch('AWS_S3_ASSET_HOST'), 'images', uuid, 'span8.jpg'),
              'urlSpan12' => File.join(ENV.fetch('AWS_S3_ASSET_HOST'), 'images', uuid, 'span12.jpg'),
              'urlThumbnail' => File.join(ENV.fetch('AWS_S3_ASSET_HOST'), 'images', uuid, 'thumbnail.jpg')
            }
          ],
          'totalCount' => 1
        }
      }
    ]
  end

  it 'returns all feilds' do
    expect(result.values).to eq expected_result
  end
end
