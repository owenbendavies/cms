require 'rails_helper'

RSpec.feature 'LoaderIO' do
  scenario 'visiting the page' do
    visit_page '/loaderio-12345.txt'

    expect(page).to have_content 'loaderio-12345'
    expect(response_headers['Content-Type']).to eq 'text/plain; charset=utf-8'
  end

  scenario 'with non txt extension' do
    visit '/loaderio-12345'

    expect(page).to have_content 'Page Not Found'
    expect(page.status_code).to eq 404
  end
end
