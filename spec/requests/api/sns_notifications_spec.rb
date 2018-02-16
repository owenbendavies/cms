require 'rails_helper'

RSpec.describe 'POST /api/sns_notifications' do
  let(:request_headers) { { 'Content-Type' => 'text/plain; charset=UTF-8' } }

  let(:request_host) { new_host }

  let(:request_params) do
    Rails.root.join('spec', 'assets', 'sns', 'notification.json').read
  end

  let(:expected_status) { 201 }

  before do
    verifier = instance_double(Aws::SNS::MessageVerifier)
    allow(verifier).to receive(:authenticate!).with(request_params)
    allow(Aws::SNS::MessageVerifier).to receive(:new).and_return(verifier)
  end

  include_examples(
    'swagger documentation',
    description: 'Creates an AWS SNS notification',
    model: nil
  )

  it 'saves the sns message' do
    request_page
    expect(SnsNotification.last.message).to eq JSON.parse(request_params)
  end
end
