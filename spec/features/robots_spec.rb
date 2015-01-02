require 'rails_helper'

RSpec.describe 'robots', type: :feature do
  describe 'show' do
    it 'has robots files' do
      visit_page '/robots.txt'

      expect(body).to eq <<EOF
Sitemap: http://localhost:37511/sitemap.xml

User-agent: *
Disallow:
EOF

      content_type = response_headers['Content-Type']
      expect(content_type).to eq 'text/plain; charset=utf-8'
    end

    context 'https' do
      it 'has https link to sitemap' do
        page.driver.browser.header('X-Forwarded-Proto', 'https')

        visit_page '/robots.txt'

        expect(body).to include 'https://localhost:37511/sitemap.xml'
      end
    end
  end

  it 'renders page not found when not txt' do
    visit '/robots'
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
  end
end
