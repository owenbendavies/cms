ApiPagination.configure do |config|
  config.page_header = 'X-Page'
  config.per_page_header = 'X-Per-Page'
  config.total_header = 'X-Total'
end
