module RequestTestHelpers
  def login_as_request_user
    login_as request_user if defined? request_user
  end

  def request_page
    login_as_request_user
    host! request_host
    send(request_method, request_path, headers: request_headers, params: request_params)
    expect(response).to have_http_status expected_status
  end

  def json_body
    JSON.parse(response.body)
  end
end

RSpec.configuration.include RequestTestHelpers, type: :request
