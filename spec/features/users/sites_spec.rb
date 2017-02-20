# TODO: refactor

require 'rails_helper'

RSpec.feature 'User sites' do
  let(:go_to_url) { '/user/sites' }

  as_a 'authorized user', :site_user, 'Sites', 'list' do
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
      let(:environment_variables) { { DISABLE_SSL: nil } }

      scenario 'visiting the page' do
        visit_200_page

        links = all('#cms-article a')
        expect(links[0]['href']).to eq 'https://localhost'
      end
    end
  end
end
