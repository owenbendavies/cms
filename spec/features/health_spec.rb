require 'rails_helper'

RSpec.feature 'Health check' do
  context 'unknown site' do
    before do
      site.destroy!
    end

    scenario 'visiting the page' do
      visit_page '/health.txt'
      expect(page).to have_content 'ok'
      expect(response_headers['Content-Type']).to eq 'text/plain; charset=utf-8'
    end

    scenario 'with non txt extension' do
      visit '/health.xml'
      expect(page).to have_content 'Site Not Found'
      expect(page.status_code).to eq 404
    end
  end

  context 'known site' do
    scenario 'visiting the page' do
      visit_page '/health.txt'
      expect(page).to have_content 'ok'
      expect(response_headers['Content-Type']).to eq 'text/plain; charset=utf-8'
    end

    scenario 'with non txt extension' do
      visit '/health'
      expect(page).to have_content 'Page Not Found'
      expect(page.status_code).to eq 404
    end
  end
end
