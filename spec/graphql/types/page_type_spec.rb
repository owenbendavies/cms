require 'rails_helper'

RSpec.describe Types::PageType do
  subject(:result) { GraphqlSchema.execute(query, context:) }

  let(:site) { create(:site) }
  let(:user) { build(:user, site:) }
  let(:context) { { user:, site: } }

  let!(:page) { create(:page, site:) }

  let(:query) do
    <<~BODY
      query {
        pages {
          nodes {
            contactForm
            createdAt
            customHtml
            htmlContent
            id
            name
            private
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
        'pages' => {
          'nodes' => [
            {
              'contactForm' => page.contact_form,
              'createdAt' => page.created_at.iso8601,
              'customHtml' => page.custom_html,
              'htmlContent' => page.html_content,
              'id' => Base64.urlsafe_encode64("Page-#{page.id}"),
              'name' => page.name,
              'private' => page.private,
              'updatedAt' => page.updated_at.iso8601,
              'url' => page.url
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
