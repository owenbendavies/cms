require 'spec_helper'

describe 'loaderio' do
  include_context 'default_site'

  it 'renders loaderio verification' do
    visit_page '/loaderio-12345.txt'

    page.should have_content 'loaderio-12345'
  end

  it 'renders page not found when not txt' do
    visit '/loaderio-12345'
    page.status_code.should eq 404
    page.should have_content 'Page Not Found'
  end
end
