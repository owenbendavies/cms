require 'rails_helper'

RSpec.feature 'Unknown routes' do
  scenario 'visiting /' do
    visit_page '/'
    expect(current_path).to eq '/home'
  end

  scenario 'for urls with .html in' do
    visit_404_page '/home.html'
  end

  scenario 'for unkown format' do
    visit_404_page '/home.txt'
  end

  scenario 'for unknown accept header' do
    page.driver.header('Accept', 'application/json')
    visit_404_page '/home'
  end

  scenario 'for urls with capitals in' do
    visit_404_page '/Home'
  end

  scenario 'for urls with dots in path' do
    visit_404_page '/file.pid/file'
  end

  scenario 'for unknown url' do
    visit_404_page '/badroute'
  end

  scenario 'unknown site' do
    site.destroy!
    visit_page '/home'

    expect(page).to have_title 'Site Not Found'
    expect(page.status_code).to eq 404
  end
end
