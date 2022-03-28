require 'rails_helper'

RSpec.describe Types::SiteType do
  subject(:result) { GraphqlSchema.execute(query, context:) }

  let(:site) { create(:site) }
  let(:user) { build(:user, site:) }
  let(:context) { { user:, site: } }

  let(:query) do
    <<~BODY
      query {
        sites {
          nodes {
            address
            charityNumber
            createdAt
            css
            email
            googleAnalytics
            host
            id
            mainMenuInFooter
            name
            separateHeader
            sidebarHtmlContent
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
        'sites' => {
          'nodes' => [
            {
              'address' => site.address,
              'charityNumber' => site.charity_number,
              'createdAt' => site.created_at.iso8601,
              'css' => site.css,
              'email' => site.email,
              'googleAnalytics' => site.google_analytics,
              'host' => site.host,
              'id' => Base64.urlsafe_encode64("Site-#{site.id}"),
              'mainMenuInFooter' => site.main_menu_in_footer,
              'name' => site.name,
              'separateHeader' => site.separate_header,
              'sidebarHtmlContent' => site.sidebar_html_content,
              'updatedAt' => site.updated_at.iso8601
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
