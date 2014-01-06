require 'spec_helper'

describe 'unknown domain' do
  it 'displays site not found' do
    visit '/home'
    page.status_code.should eq 404

    find('title', visible: false).native.text.should eq 'Site Not Found'

    page.should have_content 'Site Not Found'
    page.should have_content 'Sorry'
  end
end
