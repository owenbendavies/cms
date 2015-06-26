require 'rails_helper'

RSpec.feature 'robots.txt' do
  scenario 'visiting the page' do
    visit_page '/robots.txt'

    expect(body).to eq <<EOF
Sitemap: http://localhost:37511/sitemap.xml

User-agent: *
Disallow:
EOF

    expect(response_headers['Content-Type']).to eq 'text/plain; charset=utf-8'
  end

  scenario 'visiting via https' do
    page.driver.header('X-Forwarded-Proto', 'https')
    visit_page '/robots.txt'

    expect(body).to include 'https://localhost:37511/sitemap.xml'
  end

  scenario 'with non txt extension' do
    visit '/robots'

    expect(page).to have_content 'Page Not Found'
    expect(page.status_code).to eq 404
  end
end
