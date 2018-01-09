require 'rails_helper'

RSpec.describe 'POST /api/sns_notifications' do
  let(:request_host) { new_host }

  let(:request_params) do
    Rails.root.join('spec', 'assets', 'sns', 'notification.json').read
  end

  let(:expected_result) do
    {
      'message' => JSON.parse(request_params),
      'created_at' => new_sns.created_at.iso8601,
      'updated_at' => new_sns.updated_at.iso8601
    }
  end

  let(:new_sns) { SnsNotification.last }

  before do
    verifier = instance_double(Aws::SNS::MessageVerifier)
    allow(verifier).to receive(:authenticate!).with(request_params)
    allow(Aws::SNS::MessageVerifier).to receive(:new).and_return(verifier)
  end

  it 'saves the sns message' do
    request_page(expected_status: 201)
    expect(json_body).to eq expected_result
  end
end
