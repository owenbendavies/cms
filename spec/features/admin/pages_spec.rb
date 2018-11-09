require 'rails_helper'

RSpec.feature 'Admin pages' do
  context 'with multiple pages' do
    let!(:pages) do
      ('a'..'k').map do |i|
        FactoryBot.create(:page, name: "Page #{i}", site: site)
      end
    end

    before do
      login_as site_user
      visit '/home'
      click_link 'Admin'
      click_link 'Pages'
    end

    scenario 'clicking pagination' do
      expect(all('table tbody tr').size).to eq 10

      expect(page).to have_content pages.first.name
      expect(page).not_to have_content pages.last.name

      click_button 'Next'

      expect(page).not_to have_content pages.first.name
      expect(page).to have_content pages.last.name

      click_button 'Prev'

      expect(page).to have_content pages.first.name
      expect(page).not_to have_content pages.last.name
    end

    scenario 'deleteing pages' do
      find('table tbody tr:nth-child(1) td:nth-child(1) > span').click
      find('table tbody tr:nth-child(2) td:nth-child(1) > span').click
      find('table tbody tr:nth-child(3) td:nth-child(1) > span').click

      click_button 'Delete'

      expect(page).to have_content '3 elements deleted'
    end
  end
end
