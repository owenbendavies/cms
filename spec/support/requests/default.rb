RSpec.configuration.include Warden::Test::Helpers, type: :request

RSpec.shared_context 'with requests' do
  let(:request_description) do
    self.class.metadata[:full_description].match %r{(GET|POST|PUT|PATCH|DELETE) ([a-z0-9/_:.]+)}
  end

  let(:request_headers) { {} }
  let(:request_host) { site.host }

  let(:request_method) do
    raise 'request_method not set' unless request_description
    request_description.to_a[1].downcase.to_sym
  end

  let(:request_params) { {} }

  let(:request_path) do
    raise 'request_path not set' unless request_description
    path = request_description.to_a[2]
    path.gsub!(':id', request_path_id.to_s) if path.include? ':id'
    path
  end

  let(:site) { FactoryBot.create(:site) }

  def request_page(expected_status: 200)
    login_as request_user if defined? request_user
    host! request_host
    send(request_method, request_path, headers: request_headers, params: request_params)
    expect(response).to have_http_status expected_status
  end

  def json_body
    JSON.parse(response.body)
  end
end

RSpec.configuration.include_context 'with requests', type: :request

RSpec.shared_examples 'renders html page not found' do
  it 'renders html page not found' do
    request_page(expected_status: 404)
    expect(body).to include 'Page Not Found'
  end
end

RSpec.shared_examples 'returns 406' do
  it 'returns 406' do
    request_page(expected_status: 406)
    expect(body).to be_empty
  end
end
