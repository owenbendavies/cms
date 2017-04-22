require 'rails_helper'

RSpec.feature 'Site layouts' do
  before do
    site.update! sidebar_html_content: '<h1>Test</h1>'
    login_as site_user
    navigate_via_topbar menu: 'Site', title: 'Site Settings', icon: 'cog'
  end

  scenario 'one_column' do
    expect(find_field('Layout').value).to eq site.layout

    select 'One column', from: 'Layout'
    click_button 'Update Site'

    expect(page).to have_content 'Site successfully updated'
    expect(page).to have_selector '#cms-article.col-sm-12'
  end

  scenario 'right_sidebar' do
    expect(find_field('Layout').value).to eq site.layout

    select 'Right sidebar', from: 'Layout'
    click_button 'Update Site'

    expect(page).to have_content 'Site successfully updated'
    expect(page).to have_selector '#cms-article.col-sm-8'
    expect(page).to have_selector '#cms-sidebar.col-sm-4 h1'
  end

  scenario 'small_right_sidebar' do
    expect(find_field('Layout').value).to eq site.layout

    select 'Small right sidebar', from: 'Layout'
    click_button 'Update Site'

    expect(page).to have_content 'Site successfully updated'
    expect(page).to have_selector '#cms-article.col-sm-9'
    expect(page).to have_selector '#cms-sidebar.col-sm-3 h1'
  end
end
