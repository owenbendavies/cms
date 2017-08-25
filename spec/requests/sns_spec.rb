require 'rails_helper'

RSpec.describe 'POST /sns' do
  let(:request_params) do
    Rails.root.join('spec', 'assets', 'sns', 'notification.json').read
  end

  before do
    verifier = instance_double(Aws::SNS::MessageVerifier)
    expect(verifier).to receive(:authenticate!).with(request_params)
    expect(Aws::SNS::MessageVerifier).to receive(:new).and_return(verifier)
  end

  it 'saves the notification' do
    expect { request_page(expected_status: 204) }.to change(SnsNotification, :count).by(1)
  end

  it 'saves message contents' do
    request_page(expected_status: 204)
    expect(SnsNotification.last.message).to eq JSON.parse(request_params)
  end
end
