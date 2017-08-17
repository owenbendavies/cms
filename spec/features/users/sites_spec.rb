require 'rails_helper'

RSpec.feature 'User sites' do
  before do
    FactoryGirl.create(:site)
    login_as site_user
    navigate_via_topbar menu: site_user.name, title: 'Sites', icon: 'list'
  end

  context 'when ssl is disabled' do
    let(:environment_variables) { { DISABLE_SSL: 'true' } }

    scenario 'list of sites with http' do
      links = all('.article a')
      expect(links.size).to eq 1

      expect(links[0].text).to eq 'localhost'
      expect(links[0]['href']).to eq 'http://localhost'
    end
  end

  context 'when ssl is enabled' do
    scenario 'list of sites with https' do
      links = all('.article a')
      expect(links[0]['href']).to eq 'https://localhost'
    end
  end
end
