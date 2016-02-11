require 'rails_helper'

RSpec.feature 'Site layouts' do
  let(:go_to_url) { '/site/edit' }

  before do
    site.sidebar_html_content = '<h1>Test</h1>'
    site.save!
  end

  as_a 'authorized user' do
    scenario 'changing to one_column' do
      visit_200_page

      expect(find_field('Layout').value).to eq site.layout

      select 'One column', from: 'Layout'
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(page).to have_selector '#cms-article.col-sm-12'
    end

    scenario 'changing to right_sidebar' do
      visit_200_page

      expect(find_field('Layout').value).to eq site.layout

      select 'Right sidebar', from: 'Layout'
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(page).to have_selector '#cms-article.col-sm-8'
      expect(page).to have_selector '#cms-sidebar.col-sm-4 h1'
    end

    scenario 'changing to small_right_sidebar' do
      visit_200_page

      expect(find_field('Layout').value).to eq site.layout

      select 'Small right sidebar', from: 'Layout'
      click_button 'Update Site'

      expect(page).to have_content 'Site successfully updated'
      expect(page).to have_selector '#cms-article.col-sm-9'
      expect(page).to have_selector '#cms-sidebar.col-sm-3 h1'
    end
  end
end
