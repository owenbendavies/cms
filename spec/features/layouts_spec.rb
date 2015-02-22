# coding: utf-8
require 'rails_helper'

RSpec.describe 'layouts', type: :feature do
  shared_context 'layout' do |layout|
    before do
      site.main_menu_page_ids = [home_page.id, test_page.id]
      site.main_menu_in_page = true
      site.main_menu_in_footer = true
      site.layout = layout
      site.save!

      visit_page '/home'
    end

    it 'has all sections' do
      expect(page).to have_selector 'header#page_header'
      expect(page).to have_selector '#main_menu'
      expect(page).to have_selector 'article#main_article'
      expect(page).to have_selector '#footer_main_menu'
      expect(page).to have_selector 'footer#page_footer'
    end
  end

  context 'one_column' do
    it_behaves_like 'layout', 'one_column' do
    end
  end

  %w(right_sidebar small_right_sidebar).each do |layout|
    context layout do
      it_behaves_like 'layout', layout do
        it 'has sidebar' do
          expect(page).to have_selector 'aside#sidebar'
        end
      end
    end
  end
end
