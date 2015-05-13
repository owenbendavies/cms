# coding: utf-8
require 'rails_helper'

RSpec.describe 'layouts', type: :feature do
  it 'renders one_column layout' do
    site.layout = 'one_column'
    site.save!

    visit_page '/test_page'

    expect(page).to have_selector '#cms-article.col-sm-12 header'
  end

  it 'renders right_sidebar layout' do
    site.layout = 'right_sidebar'
    site.sidebar_html_content = '<h1>Test</h1>'
    site.save!

    visit_page '/test_page'

    expect(page).to have_selector '#cms-article.col-sm-8 header'
    expect(page).to have_selector '#cms-sidebar.col-sm-4 h1'
  end

  it 'renders small_right_sidebar layout' do
    site.layout = 'small_right_sidebar'
    site.sidebar_html_content = '<h1>Test</h1>'
    site.save!

    visit_page '/test_page'

    expect(page).to have_selector '#cms-article.col-sm-9 header'
    expect(page).to have_selector '#cms-sidebar.col-sm-3 h1'
  end
end
