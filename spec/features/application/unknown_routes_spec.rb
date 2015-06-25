require 'rails_helper'

RSpec.feature 'Unknown routes' do
  scenario 'for unkown format' do
    visit '/home.txt'

    expect(page).to have_content 'Page Not Found'
    expect(page.status_code).to eq 404
  end

  scenario 'for unknown accept header' do
    page.driver.header('Accept', 'application/json')
    visit '/home'

    expect(page).to have_content 'Page Not Found'
    expect(page.status_code).to eq 404
  end

  scenario 'for urls with capitals in' do
    visit '/Home'

    expect(page).to have_content 'Page Not Found'
    expect(page.status_code).to eq 404
  end

  scenario 'for urls with dots in path' do
    visit '/file.pid/file'

    expect(page).to have_content 'Page Not Found'
    expect(page.status_code).to eq 404
  end

  scenario 'for unknown url' do
    visit '/badroute'

    expect(page).to have_content 'Page Not Found'
    expect(page.status_code).to eq 404
  end
end
