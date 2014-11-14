require 'rails_helper'

RSpec.describe 'images', type: :feature do
  before do
    @image = FactoryGirl.create(:image, site: @site)
  end

  describe 'index' do
    let(:go_to_url) { '/site/images' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      it 'has list of images' do
        expect(find('#main_article h1').text).to eq 'Images'
        expect(page).to have_selector 'h1 i.glyphicon-picture'

        image = find("#main_article a[href='#{@image.file.url}'] img")
        expect(image['src']).to eq @image.file.span3.url
        expect(image['alt']).to eq @image.name

        expect(page).to have_content @image.name
      end

      it 'has link in topbar' do
        visit_page '/home'

        within('#topbar') do
          click_link 'Images'
        end

        expect(current_path).to eq go_to_url
      end
    end
  end
end
