require 'rails_helper'

RSpec.describe Types::ImageType do
  subject(:result) { GraphqlSchema.execute(query, context: context) }

  let(:site) { FactoryBot.create(:site) }
  let(:user) { FactoryBot.build(:user, site: site) }
  let(:context) { { user: user, site: site } }

  let!(:image) { FactoryBot.create(:image, site: site) }

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
              'url' => image.file.public_url
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
