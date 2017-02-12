RSpec.shared_context 'requests' do
  let(:request_description) do
    self.class.metadata[:full_description].match %r{^(GET|PUT|DELETE) ([a-z/]+)}
  end

  let(:request_headers) { {} }
  let(:request_host) { site.host }

  let(:request_method) do
    if request_description
      request_description.to_a[1].downcase.to_sym
    else
      :get
    end
  end

  let(:request_params) { {} }

  let(:request_path) do
    if request_description
      request_description.to_a[2]
    else
      '/sitemap'
    end
  end

  let(:site) { FactoryGirl.create(:site) }

  def request_page(expected_status: 200)
    login_as user if defined? user
    host! request_host
    send(request_method, request_path, headers: request_headers, params: request_params)
    expect(response).to have_http_status expected_status
  end
end

RSpec.shared_context 'renders page not found' do
  it 'renders page not found' do
    request_page(expected_status: 404)
    expect(body).to include 'Page Not Found'
  end
end

RSpec.shared_context 'authenticated page' do
  context 'as a unauthenticated user' do
    include_context 'renders page not found'
  end

  context 'as a user from another site' do
    let(:user) { FactoryGirl.create(:user) }

    include_context 'renders page not found'
  end

  context 'as a site user' do
    let(:user) do
      FactoryGirl.create(:user).tap do |user|
        user.site_settings.create!(site: site)
      end
    end

    it 'renders 200' do
      request_page
    end
  end
end

RSpec.configuration.include_context 'requests', type: :request

RSpec.configuration.include Warden::Test::Helpers, type: :request
