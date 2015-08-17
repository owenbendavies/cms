require 'rails_helper'

RSpec.feature 'List images' do
  let!(:image) { FactoryGirl.create(:image) }
  let!(:other_site_image) { FactoryGirl.create(:image, site: FactoryGirl.create(:site)) }

  let(:go_to_url) { '/site/images' }

  include_examples 'restricted page with topbar link', 'Images'

  it_behaves_like 'logged in site user' do
    scenario 'visiting the page' do
      image_tag = find("#cms-article a[href='#{image.file.url}'] img")
      expect(image_tag['src']).to eq image.file.span3.url
      expect(image_tag['alt']).to eq image.name

      expect(page).to have_content image.name

      expect(page).to_not have_content other_site_image.name
    end

    include_examples 'page with topbar link', 'Images', 'picture-o'
  end
end
