require 'rails_helper'

RSpec.feature 'Web server' do
  scenario 'visiting a font' do
    font_path = Dir.glob(Rails.root.join('public/assets/**/*.woff')).first
    font_path.gsub!(Rails.root.join('public').to_s, '')
    visit_200_page font_path

    expect(response_headers['Access-Control-Allow-Origin']).to eq '*'
  end

  scenario 'attacking the site' do
    page.driver.header('X_FORWARDED_FOR', 'x')
    page.driver.header('CLIENT_IP', 'y')

    unchecked_visit '/home'

    expect(page.status_code).to eq 403
  end

  scenario 'content security policy' do
    visit_200_page '/home'

    expect(response_headers['Content-Security-Policy']).to eq [
      "default-src 'none'",
      "connect-src 'self'",
      "font-src 'self' https:",
      "img-src 'self' https: data:",
      "script-src 'self' https: 'unsafe-inline'",
      "style-src 'self' https: 'unsafe-inline'"
    ].join('; ') + ';'
  end

  context 'with gzip' do
    before do
      page.driver.header('ACCEPT_ENCODING', 'gzip, deflate')
    end

    scenario 'visiting a page' do
      visit_200_page '/home'

      expect(response_headers['Content-Encoding']).to eq 'gzip'
    end

    scenario 'visiting an asset with gzip' do
      asset_file_path = Dir.glob(Rails.root.join('public/assets/application*.css')).first
      asset_file_path.gsub!(Rails.root.join('public').to_s, '')
      visit_200_page asset_file_path

      expect(response_headers['Content-Encoding']).to eq 'gzip'
    end
  end
end
