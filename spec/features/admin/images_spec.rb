require 'rails_helper'

RSpec.feature 'Admin images' do
  def navigate_to_admin_images
    click_link 'Admin'
    click_link 'Images'
  end

  before do
    login_as site_user
    visit '/home'
  end

  context 'with a image' do
    let!(:image) { create(:image, site: site) }

    scenario 'list of images' do
      navigate_to_admin_images
      expect(find('img')['src']).to eq image.file.thumbnail.public_url
    end
  end

  context 'with multiple images' do
    let!(:images) do
      ('a'..'m').map do |i|
        create(:image, name: "Image #{i}", site: site)
      end
    end

    scenario 'clicking pagination' do
      navigate_to_admin_images
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
