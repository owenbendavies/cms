require 'rails_helper'

RSpec.feature 'List images' do
  let!(:image) { FactoryGirl.create(:image, site: site) }
  let(:go_to_url) { '/site/images' }

  it_behaves_like 'restricted page'

  it_behaves_like 'logged in user' do
    scenario 'visiting the page' do
      expect(find('#cms-article h1').text).to eq 'Images'

      image_tag = find("#cms-article a[href='#{image.file.url}'] img")
      expect(image_tag['src']).to eq image.file.span3.url
      expect(image_tag['alt']).to eq image.name

      expect(page).to have_content image.name
    end

    include_examples 'page with topbar link', 'Images', 'picture-o'
  end
end
