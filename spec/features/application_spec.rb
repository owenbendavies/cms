require 'rails_helper'

RSpec.describe 'application', type: :feature do
  it 'redirects root path to home' do
    visit '/'
    expect(current_path).to eq '/home'
  end

  it 'renders page not found for urls with unkown format in' do
    visit '/home.txt'
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
  end

  it 'renders page not found for unknown accept header' do
    page.driver.header('Accept', 'application/json')
    visit '/home'
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
  end

  it 'renders page not found for urls with capitals in' do
    visit '/Home'
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
  end

  it 'renders page not found for urls with dots in path' do
    visit '/file.pid/file'
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
  end

  it 'renders page not found for unknown url' do
    visit '/badroute'
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
  end

  context 'http' do
    before do
      visit_page '/home'
    end

    it 'sets session cookie as http only' do
      expect(response_headers['Set-Cookie']).to_not include 'secure'
    end

    it 'sets content security policy to *' do
      expect(response_headers['Content-Security-Policy']).to eq [
        'default-src *',
        'img-src * data:',
        "script-src * 'unsafe-inline'",
        "style-src * 'unsafe-inline'"
      ].join('; ') + ';'
    end

    it 'does not set strict transport security header' do
      expect(response_headers['Strict-Transport-Security']).to eq nil
    end
  end

  context 'https' do
    before do
      page.driver.header('X-Forwarded-Proto', 'https')
      visit_page '/home'
    end

    it 'sets session cookie as https' do
      expect(response_headers['Set-Cookie']).to include 'secure'
    end

    it 'sets content security policy to https only' do
      expect(response_headers['Content-Security-Policy']).to eq [
        'default-src https:',
        'img-src https: data:',
        "script-src https: 'unsafe-inline'",
        "style-src https: 'unsafe-inline'"
      ].join('; ') + ';'
    end

    it 'sets strict transport security header' do
      expect(response_headers['Strict-Transport-Security'])
        .to eq 'max-age=2592000'
    end
  end

  it 'renders site not found for unknown site' do
    site.destroy!
    visit '/home'
    expect(page.status_code).to eq 404

    expect(page).to have_title 'Site Not Found'

    expect(page).to have_content 'Site Not Found'
    expect(page).to have_content 'Sorry'
  end

  it 'renders page not found for urls with .html in' do
    visit '/home.html'
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
  end

  it 'protects against attacks' do
    page.driver.header('X_FORWARDED_FOR', 'x')
    page.driver.header('CLIENT_IP', 'y')
    visit '/home'
    expect(page.status_code).to eq 403
  end

  it 'stores session data in database' do
    visit_page '/home'
    expect(response_headers['Set-Cookie'])
      .to match(/^_cms_session=[0-9a-f]{32};.*/)
  end

  it 'serves fonts up with CORS' do
    font_path  = Dir.glob(Rails.root.join('public/assets/**/*.woff')).first
    font_path.gsub!(Rails.root.join('public').to_s, '')

    expect(font_path).to_not be_blank

    visit_page font_path

    expect(response_headers['Access-Control-Allow-Origin']).to eq '*'
  end

  it 'serves gziped assets' do
    asset_file_path = Dir.glob(Rails.root.join('public/assets/*.gz')).first
    asset_file_path.gsub!(Rails.root.join('public').to_s, '')
    asset_file_path.gsub!(/\.gz$/, '')

    expect(asset_file_path).to_not be_blank

    page.driver.header('ACCEPT_ENCODING', 'gzip, deflate')
    visit_page asset_file_path

    expect(response_headers['Content-Encoding']).to eq 'gzip'
  end
end
