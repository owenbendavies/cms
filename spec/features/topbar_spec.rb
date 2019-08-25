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

    it_behaves_like 'when on mobile' do
      scenario 'navigating to page via dropdowns' do
        visit '/home'

        within topbar_selector do
          expect(page).not_to have_link 'Page'
          expect(page).not_to have_link 'New Page'

          click_button 'Account menu'

          expect(page).not_to have_link 'New Page'

          click_link 'Page'
          click_link 'New Page'
        end

        expect(page).to have_content 'New Page'
        expect(page).to have_current_path '/new'
      end
    end
  end
end
