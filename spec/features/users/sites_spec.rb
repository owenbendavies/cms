require 'rails_helper'

RSpec.feature 'User sites' do
  let(:go_to_url) { '/user/sites' }

  authenticated_page login_user: :user, topbar_link: 'Sites', page_icon: 'list' do
    scenario 'visiting the page' do
      visit_200_page
      links = all('#cms-article a')
      expect(links.size).to eq 0
    end
  end

  as_a 'authorized user' do
    scenario 'visiting the page' do
      site_a = FactoryGirl.create(:site, host: 'alphahost')
      FactoryGirl.create(:site)
      site_user.site_settings.create!(site: site_a)
      visit_200_page

      links = all('#cms-article a')
      expect(links.size).to eq 2

      expect(links[0].text).to eq 'alphahost'
      expect(links[0]['href']).to eq 'http://alphahost'

      expect(links[1].text).to eq 'localhost'
      expect(links[1]['href']).to eq 'http://localhost'
    end

    context 'when ssl is enabled' do
      around do |example|
        ClimateControl.modify(DISABLE_SSL: nil) do
          example.run
        end
      end

      scenario 'visiting the page' do
        visit_200_page

        links = all('#cms-article a')
        expect(links[0]['href']).to eq 'https://localhost'
      end
    end
  end
end
