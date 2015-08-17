require 'rails_helper'

RSpec.feature 'Web server' do
  scenario 'visiting a font' do
    font_path = Dir.glob(Rails.root.join('public/assets/**/*.woff')).first
    font_path.gsub!(Rails.root.join('public').to_s, '')

    expect(font_path).to_not be_blank

    visit_200_page font_path

    expect(response_headers['Access-Control-Allow-Origin']).to eq '*'
  end

  scenario 'visiting an asset with gzip' do
    asset_file_path = Dir.glob(Rails.root.join('public/assets/*.gz')).first
    asset_file_path.gsub!(Rails.root.join('public').to_s, '')
    asset_file_path.gsub!(/\.gz$/, '')

    expect(asset_file_path).to_not be_blank

    page.driver.header('ACCEPT_ENCODING', 'gzip, deflate')
    visit_200_page asset_file_path

    expect(response_headers['Content-Encoding']).to eq 'gzip'
  end

  scenario 'attacking the site' do
    page.driver.header('X_FORWARDED_FOR', 'x')
    page.driver.header('CLIENT_IP', 'y')

    visit_page '/home'

    expect(page.status_code).to eq 403
  end
end
