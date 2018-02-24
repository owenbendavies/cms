RSpec.shared_examples 'sets headers' do
  it 'sets only expected headers' do
    request_page
    expect(response.headers.keys).to contain_exactly(*expected_headers)
  end

  it 'sets correct values for headers' do
    request_page
    expect(non_random_headers).to eq expected_non_random_headers
  end
end
