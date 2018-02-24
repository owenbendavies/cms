RSpec.shared_examples 'renders html page not found' do
  let(:expected_status) { 404 }

  it 'renders html page not found' do
    request_page
    expect(body).to include 'Page Not Found'
  end
end
