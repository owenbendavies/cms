RSpec.shared_context 'requests' do
  let(:request_method) { :get }
  let(:request_path) { '/home' }
  let(:request_headers) { {} }
  let(:request_params) { {} }

  def request_page
    login_as user if defined? user
    send(request_method, request_path, headers: request_headers, params: request_params)
  end
end

RSpec.configuration.include_context 'requests', type: :request

RSpec.configuration.include Warden::Test::Helpers, type: :request
