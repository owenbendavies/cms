require 'rails_helper'

describe 'stylesheets' do
  context 'known site' do
    before do
      @site = FactoryGirl.build(:site)
      @site.css = "body {\r\n  padding: 4em;\r\n}"
      @site.save!
    end

    it 'renders stylesheet' do
      visit_page '/stylesheets/e6df26f541ebad8e8fed26a84e202a7c.css'
      expect(body).to eq "body {\r\n  padding: 4em;\r\n}"
      expect(response_headers['Content-Type']).to eq 'text/css; charset=utf-8'
      expect(response_headers['Cache-Control']).to eq 'max-age=31557600, public'
    end

    it 'renders any sites stylesheet' do
      other_site = FactoryGirl.build(:site, host: 'www.example.com')
      other_site.css = 'body{background-color: red}'
      other_site.save!

      visit_page '/stylesheets/b1192d422b8c8999043c2abd1b47b750.css'
      expect(body).to eq 'body{background-color: red}'
    end

    it 'renders page not found when not found' do
      visit '/stylesheets/unknown.css'
      expect(page.status_code).to eq 404
      expect(page).to have_content 'Page Not Found'
    end
  end

  context 'unknown site' do
    it 'renders stylesheet' do
      site = FactoryGirl.build(:site, host: 'www.example.com')
      site.css = "body {\r\n  padding: 4em;\r\n}"
      site.save!

      visit_page '/stylesheets/e6df26f541ebad8e8fed26a84e202a7c.css'
      expect(body).to eq "body {\r\n  padding: 4em;\r\n}"
    end

    it 'renders site not found when not found' do
      visit '/stylesheets/unknown.css'
      expect(page.status_code).to eq 404
      expect(page).to have_content 'Site Not Found'
    end
  end
end
