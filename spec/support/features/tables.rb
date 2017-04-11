RSpec.shared_context 'tables' do
  let(:table_header_text) do
    all('table thead th').map(&:text)
  end

  let(:table_rows) do
    all('table tbody tr').map { |row| row.all('td') }
  end
end

RSpec.configuration.include_context 'tables', type: :feature
