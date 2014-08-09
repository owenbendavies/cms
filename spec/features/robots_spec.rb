require 'rails_helper'

RSpec.describe 'robots', type: :feature do
  include_context 'default_site'

  describe 'show' do
    before { visit_page '/robots.txt' }

    it 'has robots files' do
      expect(page).to have_content 'Sitemap: http://localhost:37511/sitemap.xml'
      expect(page).to have_content 'User-agent: *'
      expect(page).to have_content 'Disallow:'
      expect(response_headers['Content-Type']).to eq 'text/plain; charset=utf-8'
    end

    it 'renders page not found when not txt' do
      visit '/robots'
      expect(page.status_code).to eq 404
      expect(page).to have_content 'Page Not Found'
    end
  end
end
