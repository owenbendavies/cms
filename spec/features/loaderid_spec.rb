require 'rails_helper'

describe 'loaderio' do
  include_context 'default_site'

  it 'renders loaderio verification' do
    visit_page '/loaderio-12345.txt'

    expect(page).to have_content 'loaderio-12345'
    expect(response_headers['Content-Type']).to eq 'text/plain; charset=utf-8'
  end

  it 'renders page not found when not txt' do
    visit '/loaderio-12345'
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
  end
end
