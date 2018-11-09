require 'rails_helper'

RSpec.describe Types::PageType do
  subject(:result) { GraphqlSchema.execute(query, context: context) }

  let(:site) { FactoryBot.create(:site) }
  let(:user) { FactoryBot.build(:user, site: site) }
  let(:context) { { user: user, site: site } }

  let!(:page) { FactoryBot.create(:page, site: site) }

  let(:query) do
    <<~BODY
      query {
        pages {
          nodes {
            id
            url
            name
            private
            contactForm
            htmlContent
            customHtml
            hidden
            createdAt
            updatedAt
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
              'id' => Base64.urlsafe_encode64("Page-#{page.uid}"),
              'url' => page.url,
              'name' => page.name,
              'private' => page.private,
              'contactForm' => page.contact_form,
              'htmlContent' => page.html_content,
              'customHtml' => page.custom_html,
              'hidden' => page.hidden,
              'createdAt' => page.created_at.iso8601,
              'updatedAt' => page.updated_at.iso8601
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
