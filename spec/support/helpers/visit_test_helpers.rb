module VisitTestHelpers
  def click_topbar_link(menu:, title:, icon:)
    within '.topbar' do
      expect(page).not_to have_link title
      click_link menu
      expect(page).to have_selector icon
      click_link title
    end
  end

  def navigate_via_topbar(menu:, title:, icon:)
    visit '/home'

    click_topbar_link(menu: menu, title: title, icon: icon)

    within '.article__header' do
      expect(page).to have_content title
      expect(page).to have_selector icon
    end
  end

  def click_save_and_wait_for_update(message = 'updated')
    click_button 'Save'
    expect(page).to have_content "Element #{message}"
    sleep 5
    expect(page).not_to have_content "Element #{message}"
  end
end

RSpec.configuration.include VisitTestHelpers, type: :feature
