RSpec.shared_examples 'returns 406' do
  let(:expected_status) { 406 }

  it 'returns 406' do
    request_page
    expect(body).to be_empty
  end
end
