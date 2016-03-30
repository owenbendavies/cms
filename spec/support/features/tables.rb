RSpec.shared_context 'table helpers', type: :feature do
  let(:table_header_text) do
    all('table thead th').map(&:text)
  end

  let(:table_rows) do
    all('table tbody tr').map { |row| row.all('td') }
  end
end
