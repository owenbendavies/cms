require 'spec_helper'

describe 'routes' do
  include_context 'default_site'
  include_context 'new_fields'

  it 'redirects root path to home' do
    visit '/'
    current_path.should eq '/home'
  end

  it 'renders page not found for urls with capitals in' do
    visit '/Home'
    page.status_code.should eq 404
    page.should have_content 'Page Not Found'
  end

  it 'renders page not found for urls with .html in' do
    visit '/home.html'
    page.status_code.should eq 404
    page.should have_content 'Page Not Found'
  end

  it 'renders page not found for urls with unkown format in' do
    visit '/home.txt'
    page.status_code.should eq 404
    page.should have_content 'Page Not Found'
  end

  it 'renders page not found for unknown accept header' do
    page.driver.header('Accept', 'application/json')
    visit '/home'
    page.status_code.should eq 404
    page.should have_content 'Page Not Found'
  end

  it "renders page not found for unknown url" do
    visit '/badroute'
    page.status_code.should eq 404
    page.should have_content 'Page Not Found'
  end
end
