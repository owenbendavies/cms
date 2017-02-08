# TODO: refactor

require 'rails_helper'

RSpec.feature 'robots.txt' do
  scenario 'visiting the page' do
    page.driver.header('X-Forwarded-Proto', 'https')
    visit_200_page '/robots.txt'

    expect(body).to eq <<EOF
Sitemap: https://localhost:37511/sitemap.xml

User-agent: *
Disallow:
EOF

    expect(response_headers['Content-Type']).to eq 'text/plain; charset=utf-8'
  end

  scenario 'with html extension' do
    visit_404_page '/robots'
  end

  scenario 'with non txt extension' do
    visit_406_page '/robots.xml'
  end
end
