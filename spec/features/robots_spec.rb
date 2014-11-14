require 'rails_helper'

RSpec.describe 'robots', type: :feature do
  describe 'show' do
    context 'when site allow_search_engines is true' do
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
    end

    context 'when site allow_search_engines is false' do
      it 'disallows all robots' do
        @site.allow_search_engines = false
        @site.save!

        visit_page '/robots.txt'

        expect(body).to eq <<EOF
User-agent: *
Disallow: /
EOF

        content_type = response_headers['Content-Type']
        expect(content_type).to eq 'text/plain; charset=utf-8'
      end
    end

    it 'renders page not found when not txt' do
      visit '/robots'
      expect(page.status_code).to eq 404
      expect(page).to have_content 'Page Not Found'
    end
  end
end
