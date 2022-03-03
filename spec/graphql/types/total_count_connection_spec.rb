require 'rails_helper'

RSpec.describe Types::TotalCountConnection do
  subject(:result) { GraphqlSchema.execute(query, context:) }

  let(:site) { create(:site) }
  let(:user) { build(:user, site:) }
  let(:context) { { user:, site: } }

  let!(:message1) { create(:message, site:) }
  let!(:message2) { create(:message, site:) }

  let(:query) do
    <<~BODY
      query {
        messages(first: 2, orderBy: {field: CREATED_AT, direction: ASC}) {
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
            { 'name' => message1.name },
            { 'name' => message2.name }
          ],
          'totalCount' => 3
        }
      }
    ]
  end

  before do
    create(:message, site:)
    create(:message)
  end

  it 'returns total count' do
    expect(result.values).to eq expected_result
  end
end
