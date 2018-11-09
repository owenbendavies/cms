require 'rails_helper'

RSpec.feature 'Admin sites' do
  before do
    FactoryBot.create(:site)
    login_as site_user
    visit '/home'
    click_link 'Admin'
    click_link 'Sites'
  end

  scenario 'list of sites' do
    expect(all('table tbody tr').size).to eq 1

    within('table tbody tr:nth-child(1)') do
      expect(find('td:nth-child(1)').text).to eq site.name

      within('td:nth-child(2)') do
        link = find('a')
        expect(link.text).to eq site.address
        expect(link['href']).to eq site.address
      end
    end
  end
end
