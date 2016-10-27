require 'rails_helper'

RSpec.feature 'Index images' do
  let!(:image_b) { FactoryGirl.create(:image, name: 'Image B', site: site) }
  let!(:image_c) { FactoryGirl.create(:image, name: 'Image C', site: site) }
  let!(:image_a) { FactoryGirl.create(:image, name: 'Image A', site: site) }
  let!(:other_site_image) { FactoryGirl.create(:image) }

  let(:go_to_url) { '/site/images' }

  authenticated_page topbar_link: 'Images', page_icon: 'picture-o' do
    scenario 'visiting the page' do
      visit_200_page

      links = all('#cms-article a')
      expect(links.size).to eq 3

      expect(links[0]['href']).to eq image_a.file.url
      image1 = links[0].find('img')
      expect(image1['src']).to eq image_a.file.span3.url
      expect(image1['alt']).to eq image_a.name

      expect(links[1]['href']).to eq image_b.file.url
      image2 = links[1].find('img')
      expect(image2['src']).to eq image_b.file.span3.url
      expect(image2['alt']).to eq image_b.name

      expect(links[2]['href']).to eq image_c.file.url
      image3 = links[2].find('img')
      expect(image3['src']).to eq image_c.file.span3.url
      expect(image3['alt']).to eq image_c.name
    end
  end
end
