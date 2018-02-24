module VisitTestHelpers
  def click_topbar_link(menu:, title:, icon:)
    within '.topbar' do
      expect(page).not_to have_link title
      click_link menu
      expect(page).to have_selector ".fa-#{icon}"
      click_link title
    end
  end

  def navigate_via_topbar(menu:, title:, icon:)
    visit_200_page '/home'

    click_topbar_link(menu: menu, title: title, icon: icon)

    expect(page).to have_header(title, icon)
  end

  def visit_200_page(url)
    visit url
    expect(page).to have_current_path url
    expect(page.status_code).to eq 200
  end

  def visit_404_page(url)
    visit url
    expect(page).to have_current_path url
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
  end
end

RSpec.configuration.include VisitTestHelpers, type: :feature
