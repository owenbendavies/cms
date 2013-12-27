require 'spec_helper'

describe 'robots' do
  include_context 'default_site'

  describe 'show' do
    before { visit_page '/robots.txt' }

    it 'has robots files' do
      page.should have_content 'Sitemap: http://localhost:37511/sitemap.xml'
      page.should have_content 'User-agent: *'
      page.should have_content 'Disallow:'
    end

    it 'renders page not found when not txt' do
      visit '/robots'
      page.status_code.should eq 404
      page.should have_content 'Page Not Found'
    end
  end
end
