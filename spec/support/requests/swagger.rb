RSpec.shared_examples 'swagger documentation' do |options|
  let(:swagger_doc) do
    get '/api/swagger_doc'
    path = request_description.to_a[2]
    path.gsub!(':id', '{uid}') if path.include? ':id'
    path.gsub!('/api', '')
    json_body.fetch('paths').fetch(path).fetch(request_method.to_s)
  end

  let(:expected_doc) do
    {
      'description' => options.fetch(:description),
      'produces' => ['application/json']
    }
  end

  it 'documents the endpoint' do
    expect(swagger_doc).to include expected_doc
  end
end
