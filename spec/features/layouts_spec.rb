#coding: utf-8
require 'rails_helper'

RSpec.describe 'layouts', type: :feature do
  include_context 'default_site'

  shared_context 'layout' do |layout|
    before do
      @site.layout = layout
      @site.save!

      visit_page '/home'
    end

    it 'has all sections' do
      expect(page).to have_selector 'header#page_header'
      expect(page).to have_selector '#main_menu'
      expect(page).to have_selector 'article#main_article'
      expect(page).to have_selector 'footer#page_footer'
    end
  end

  context 'one_column' do
    it_behaves_like 'layout', 'one_column' do
    end
  end

  [
    'right_sidebar',
    'small_right_sidebar',
  ].each do |layout|
    context layout do
      it_behaves_like 'layout', layout do
        it 'has sidebar' do
          expect(page).to have_selector 'aside#sidebar'
        end
      end
    end
  end
end
