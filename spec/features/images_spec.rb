require 'spec_helper'

describe 'images' do
  include_context 'default_site'
  include_context 'new_fields'

  before do
    @image = FactoryGirl.create(:image, site: @site)
  end

  describe 'index' do
    let(:go_to_url) { '/site/images' }

    it_should_behave_like 'restricted page'

    it_behaves_like 'logged in account' do
      it 'has list of images' do
        find('#main_article h1').text.should eq 'Images'
        page.should have_selector 'h1 i.icon-picture'

        image = find('#main_article img')
        image['src'].should eq @image.file.span3.url
        image['alt'].should eq @image.name

        page.should have_content @image.name
      end

      it 'has link in topbar' do
        visit_page '/home'

        within('#topbar') do
          click_link 'Images'
        end

        current_path.should eq go_to_url
      end
    end
  end
end
