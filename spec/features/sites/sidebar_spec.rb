require 'rails_helper'

RSpec.feature 'Site sidebar' do
  let(:sidebar) { '.sidebar' }

  scenario 'site with sidebar' do
    site.update! sidebar_html_content: '<h1>Sidebar Content</h1>'
    visit '/home'

    expect(page).to have_selector '.article.col-md-9'

    within sidebar do
      expect(page).to have_content 'Sidebar Content'
    end
  end

  scenario 'site without sidebar' do
    visit '/home'
    expect(page).to have_selector '.article.col'
    expect(page).not_to have_selector sidebar
  end
end
