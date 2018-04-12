require 'rails_helper'

RSpec.feature 'User sites' do
  before do
    FactoryBot.create(:site)
    login_as site_user
    navigate_via_topbar menu: site_user.name, title: 'Sites', icon: '.fas.fa-list.fa-fw'
  end

  scenario 'list of sites' do
    links = all('.article a')
    expect(links.size).to eq 1

    expect(links[0].text).to eq 'localhost'
    expect(links[0]['href']).to eq 'http://localhost/'
  end

  context 'with ssl is enabled' do
    let(:environment_variables) { { DISABLE_SSL: nil } }

    scenario 'list of sites with https' do
      links = all('.article a')
      expect(links[0]['href']).to eq 'https://localhost/'
    end
  end
end
