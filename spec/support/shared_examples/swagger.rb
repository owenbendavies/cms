RSpec.shared_examples 'swagger' do |options|
  let(:swagger_doc) do
    get '/api/swagger'
    path = request_description.to_a[2]
    path.gsub!(':id', '{uid}') if path.include? ':id'
    path.gsub!('/api', '')
    json_body.fetch('paths').fetch(path).fetch(request_method.to_s)
  end

  let(:expected_scheama) do
    if expected_status == 204 || options.fetch(:model).nil?
      nil
    elsif options.fetch(:model).is_a? Array
      {
        'type' => 'array',
        'items' => {
          '$ref' => "#/definitions/#{options.fetch(:model).first}"
        }
      }
    else
      {
        '$ref' => "#/definitions/#{options.fetch(:model)}"
      }
    end
  end

  let(:expected_doc) do
    {
      'description' => options.fetch(:description),
      'produces' => ['application/json'],
      'responses' => {
        expected_status.to_s => {
          'description' => options.fetch(:description),
          'schema' => expected_scheama
        }.compact
      }
    }
  end

  it 'documents the endpoint' do
    expect(swagger_doc).to include expected_doc
  end
end
