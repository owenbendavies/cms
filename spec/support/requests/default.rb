RSpec.shared_context 'requests' do
  let(:method) { :get }
  let(:path) { '/home' }
  let(:headers) { {} }
  let(:params) { {} }

  def request_page
    login_as user if defined? user
    send(method, path, headers: headers, params: params)
  end
end

RSpec.configuration.include_context 'requests', type: :request

RSpec.configuration.include Warden::Test::Helpers, type: :request
