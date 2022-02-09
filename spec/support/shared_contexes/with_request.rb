RSpec.shared_context 'with request' do
  let(:request_description) do
    self.class.metadata[:full_description].match %r{(GET|POST|PUT|PATCH|DELETE) ([a-z0-9/_:.?=-]+)}
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

  let(:expected_status) { 200 }

  let(:site) { create(:site) }
end

RSpec.configuration.include_context 'with request', type: :request
