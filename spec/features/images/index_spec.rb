require 'rails_helper'

RSpec.feature 'Images index' do
  let!(:image_b) { FactoryBot.create(:image, name: 'Image B', site: site) }
  let!(:image_c) { FactoryBot.create(:image, name: 'Image C', site: site) }
  let!(:image_a) { FactoryBot.create(:image, name: 'Image A', site: site) }

  before do
    FactoryBot.create(:image)
    login_as site_user
    navigate_via_topbar menu: 'Site', title: 'Images', icon: 'picture-o'
  end

  scenario 'list of images' do
    links = all('article a')
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
