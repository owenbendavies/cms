require 'spec_helper'

describe 'health' do
  context 'unknwon site' do
    it 'renders ok' do
      visit_page '/health.txt'
      page.should have_content 'ok'
    end

    it 'renders site not found when not txt' do
      visit '/health.xml'
      page.status_code.should eq 404
      page.should have_content 'Site Not Found'
    end
  end

  context 'known site' do
    include_context 'default_site'

    it 'renders ok' do
      visit_page '/health.txt'
      page.should have_content 'ok'
    end

    it 'renders page not found when not txt' do
      visit '/health'
      page.status_code.should eq 404
      page.should have_content 'Page Not Found'
    end
  end
end
