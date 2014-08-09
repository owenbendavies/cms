require 'rails_helper'

RSpec.describe 'health' do
  context 'unknown site' do
    it 'renders ok' do
      visit_page '/health.txt'
      expect(page).to have_content 'ok'
      expect(response_headers['Content-Type']).to eq 'text/plain; charset=utf-8'
    end

    it 'renders site not found when not txt' do
      visit '/health.xml'
      expect(page.status_code).to eq 404
      expect(page).to have_content 'Site Not Found'
    end
  end

  context 'known site' do
    include_context 'default_site'

    it 'renders ok' do
      visit_page '/health.txt'
      expect(page).to have_content 'ok'
    end

    it 'renders page not found when not txt' do
      visit '/health'
      expect(page.status_code).to eq 404
      expect(page).to have_content 'Page Not Found'
    end
  end
end
