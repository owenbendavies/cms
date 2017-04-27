RSpec.shared_context 'visit' do
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

  alias_method :unchecked_visit, :visit

  def visit(*_)
    raise "Please use methods from #{__FILE__}"
  end

  def visit_non_redirect(url)
    unchecked_visit url
    expect(current_path).to eq URI.parse(url).path
  end

  def visit_200_page(url)
    visit_non_redirect url
    expect(page.status_code).to eq 200
  end

  def visit_404_page(url)
    visit_non_redirect url
    expect(page.status_code).to eq 404
    expect(page).to have_content 'Page Not Found'
  end
end

RSpec.configuration.include_context 'visit', type: :feature
