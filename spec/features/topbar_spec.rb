require 'rails_helper'

RSpec.feature 'Topbar' do
  let(:topbar_selector) { '.topbar' }

  scenario 'no user' do
    visit '/home'

    expect(page).to have_no_selector topbar_selector
  end

  context 'when logged in' do
    before do
      login_as site_user
    end

    scenario 'navigating to home' do
      visit '/home'

      within topbar_selector do
        click_link site.name
      end

      expect(page).to have_current_path '/'
    end

    scenario 'navigating to page on mobile via dropdowns' do
      windows.first.resize_to(640, 1136)
      visit '/home'

      within topbar_selector do
        expect(page).not_to have_link 'Site'
        expect(page).not_to have_link 'Messages'

        click_button 'Account menu'

        expect(page).not_to have_link 'Messages'

        click_link 'Site'
        click_link 'Messages'
      end

      expect(page).to have_content 'Messages'
      expect(page).to have_current_path '/admin/messages'
    end
  end
end
