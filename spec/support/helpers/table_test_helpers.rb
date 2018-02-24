module TableTestHelpers
  def table_header_text
    all('table thead th').map(&:text)
  end

  def table_rows
    all('table tbody tr').map { |row| row.all('td') }
  end
end

RSpec.configuration.include TableTestHelpers, type: :feature
