require 'rails_helper'

RSpec.describe Types::SiteType do
  subject(:result) { GraphqlSchema.execute(query, context: context) }

  let(:site) { FactoryBot.create(:site) }
  let(:user) { FactoryBot.build(:user, site: site) }
  let(:context) { { user: user, site: site } }

  let(:query) do
    <<~BODY
      query {
        sites {
          nodes {
            id
            address
            host
            name
            googleAnalytics
            charityNumber
            sidebarHtmlContent
            mainMenuInFooter
            separateHeader
            email
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
        'sites' => {
          'nodes' => [
            {
              'id' => Base64.urlsafe_encode64("Site-#{site.uid}"),
              'address' => site.address,
              'host' => site.host,
              'name' => site.name,
              'googleAnalytics' => site.google_analytics,
              'charityNumber' => site.charity_number,
              'sidebarHtmlContent' => site.sidebar_html_content,
              'mainMenuInFooter' => site.main_menu_in_footer,
              'separateHeader' => site.separate_header,
              'email' => site.email,
              'createdAt' => site.created_at.iso8601,
              'updatedAt' => site.updated_at.iso8601
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
