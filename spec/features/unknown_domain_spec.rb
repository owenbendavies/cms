require 'rails_helper'

RSpec.describe 'unknown domain' do
  it 'displays site not found' do
    visit '/home'
    expect(page.status_code).to eq 404

    expect(find('title', visible: false).native.text).to eq 'Site Not Found'

    expect(page).to have_content 'Site Not Found'
    expect(page).to have_content 'Sorry'
  end
end
