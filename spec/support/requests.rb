RSpec.configuration.include Warden::Test::Helpers, type: :request

RSpec.shared_context 'requests' do
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

  let(:site) { FactoryGirl.create(:site) }

  def request_page(expected_status: 200)
    login_as user if defined? user
    host! request_host
    send(request_method, request_path, headers: request_headers, params: request_params)
    expect(response).to have_http_status expected_status
  end
end

RSpec.configuration.include_context 'requests', type: :request

RSpec.shared_examples 'renders page not found' do
  it 'renders page not found' do
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

RSpec.shared_examples 'authenticated page' do |config|
  context 'as a unauthenticated user' do
    include_examples 'renders page not found'
  end

  unless config == :skip_unauthorized_check
    context 'as a unauthorized user' do
      let(:user) do
        if defined? unauthorized_user
          unauthorized_user
        else
          FactoryGirl.create(:user)
        end
      end

      include_examples 'renders page not found'
    end
  end

  unless config == :skip_authorized_check
    context 'as a authorized user' do
      let(:user) do
        if defined? authorized_user
          authorized_user
        else
          FactoryGirl.create(:user, site: site)
        end
      end

      it 'renders page' do
        status = defined?(expected_status) ? expected_status : 200
        request_page(expected_status: status)
      end
    end
  end
end
