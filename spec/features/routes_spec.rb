require 'rails_helper'

RSpec.describe 'routes', type: :feature do
  it 'redirects root path to home' do
    visit '/'
    expect(current_path).to eq '/home'
  end

  it 'renders page not found for urls with capitals in' do
    visit '/Home'
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
  end

  it 'renders page not found for urls with .html in' do
    visit '/home.html'
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
  end

  it 'renders page not found for urls with dots in path' do
    visit '/file.pid/file'
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
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

  it "renders page not found for unknown url" do
    visit '/badroute'
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
  end
end
