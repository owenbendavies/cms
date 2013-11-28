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
  end
end
