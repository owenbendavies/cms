RSpec.shared_context 'requests' do
  let(:request_headers) { {} }
  let(:request_host) { site.host }
  let(:request_method) { :get }
  let(:request_params) { {} }
  let(:request_path) { '/sitemap' }
  let(:site) { FactoryGirl.create(:site) }

  def request_page(expected_status: 200)
    login_as user if defined? user
    host! request_host
    send(request_method, request_path, headers: request_headers, params: request_params)
    expect(response).to have_http_status expected_status
  end
end

RSpec.configuration.include_context 'requests', type: :request

RSpec.configuration.include Warden::Test::Helpers, type: :request
