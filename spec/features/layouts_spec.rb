#coding: utf-8
require 'spec_helper'

describe 'layouts' do
  include_context 'default_site'

  shared_context 'layout' do |layout|
    before do
      @site.layout = layout
      @site.save!

      visit_page '/home'
    end

    it 'has all sections' do
      page.should have_selector 'header#page_header'
      page.should have_selector '#main_menu'
      page.should have_selector 'article#main_article'
      page.should have_selector 'footer#page_footer'
    end
  end

  context 'one_column' do
    it_behaves_like 'layout', 'one_column' do
    end
  end

  [
    'right_sidebar',
    'small_right_sidebar',
    'fluid'
  ].each do |layout|
    context layout do
      it_behaves_like 'layout', layout do
        it 'has sidebar' do
          page.should have_selector 'aside#sidebar'
        end
      end
    end
  end
end
