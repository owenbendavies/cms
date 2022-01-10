Rails.application.config.public_file_server.headers = {
  'Access-Control-Allow-Methods' => 'get',
  'Access-Control-Allow-Origin' => '*',
  'Access-Control-Max-Age' => '600',
  'Cache-Control' => "public, max-age=#{Integer(1.year)}"
}
