require 'rails_helper'

RSpec.feature 'Admin images' do
  context 'with multiple images' do
    let!(:images) do
      ('a'..'m').map do |i|
        FactoryBot.create(:image, name: "Image #{i}", site: site)
      end
    end

    before do
      login_as site_user
      visit '/home'
      click_link 'Admin'
      click_link 'Images'
    end

    scenario 'clicking pagination' do
      expect(all('img').size).to eq 12

      expect(page).to have_css "img[alt='#{images.first.name}']"
      expect(page).not_to have_css "img[alt='#{images.last.name}']"

      click_button 'Next'

      expect(page).not_to have_css "img[alt='#{images.first.name}']"
      expect(page).to have_css "img[alt='#{images.last.name}']"

      click_button 'Prev'

      expect(page).to have_css "img[alt='#{images.first.name}']"
      expect(page).not_to have_css "img[alt='#{images.last.name}']"
    end
  end
end
