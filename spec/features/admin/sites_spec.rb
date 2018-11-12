require 'rails_helper'

RSpec.feature 'Admin sites' do
  context 'with a site' do
    before do
      login_as site_user
      visit '/home'
      click_link 'Admin'
      click_link 'Sites'
    end

    scenario 'list of sites' do
      within('table tbody tr:nth-child(1)') do
        expect(find('td:nth-child(1)').text).to eq site.name

        within('td:nth-child(2)') do
          expect(page).to have_link(site.address, href: site.address)
        end

        within('td:nth-child(3)') do
          expect(page).to have_link(site.email, href: "mailto:#{site.email}")
        end

        expect(find('td:nth-child(4)').text).to eq site.google_analytics
        expect(find('td:nth-child(5)').text).to eq site.charity_number
      end
    end
  end

  it_behaves_like 'when on mobile' do
    before do
      login_as site_user
      visit '/home'
      click_button 'Account menu'
      click_link 'Admin'
      find('button[aria-label="open drawer"]').click
      click_link 'Sites'
    end

    scenario 'list of sites' do
      within('.list-page ul a:nth-child(1)') do
        expect(page).to have_content site.name
        expect(page).to have_content site.address
      end
    end
  end

  context 'with multiple sites' do
    let(:site) { FactoryBot.create(:site, name: 'Site z', host: '127.0.0.1') }

    let(:sites) do
      ('a'..'k').map do |i|
        FactoryBot.create(:site, name: "Site #{i}", host: "site#{i}.com")
      end
    end

    let(:sites_user) { FactoryBot.build(:user, groups: [site.host] + sites.map(&:host)) }

    before do
      login_as sites_user
      visit '/home'
      click_link 'Admin'
      click_link 'Sites'
    end

    scenario 'clicking pagination' do
      expect(all('table tbody tr').size).to eq 10

      expect(page).to have_content sites.first.name
      expect(page).not_to have_content sites.last.name

      click_button 'Next'

      expect(page).not_to have_content sites.first.name
      expect(page).to have_content sites.last.name

      click_button 'Prev'

      expect(page).to have_content sites.first.name
      expect(page).not_to have_content sites.last.name
    end
  end
end
