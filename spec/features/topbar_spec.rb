require 'rails_helper'

RSpec.feature 'Topbar' do
  let(:topbar_selector) { '.topbar' }

  scenario 'no user' do
    visit '/home'

    expect(page).not_to have_selector topbar_selector
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
  end
end
