require 'rails_helper'

RSpec.describe 'GET /api/messages/:id' do
  let(:user) { FactoryBot.create(:user, site: site) }
  let(:message) { FactoryBot.create(:message, site: site) }
  let(:request_path_id) { message.uid }

  let(:expected_result) do
    {
      'uid' => message.uid,
      'name' => message.name,
      'email' => message.email,
      'phone' => message.phone,
      'message' => message.message,
      'created_at' => message.created_at.iso8601,
      'updated_at' => message.updated_at.iso8601
    }
  end

  it 'returns a messages' do
    request_page

    expect(json_body).to eq expected_result
  end
end
