require 'rails_helper'

RSpec.feature 'Topbar' do
  let(:topbar_selector) { '#cms-topbar' }
  let(:body_class) { '.cms-loggedin' }

  scenario 'no user' do
    visit_200_page '/home'

    expect(page).to have_no_selector topbar_selector
    expect(page).to have_no_selector body_class
  end

  context 'when logged in' do
    before do
      login_as site_user
      visit_200_page '/home'
    end

    scenario 'navigating to home' do
      within topbar_selector do
        click_link site.name
      end

      expect(current_path).to eq '/'
    end

    it_behaves_like 'mobile' do
      scenario 'navigating to page via dropdowns' do
        within topbar_selector do
          expect(page).not_to have_link 'Site'
          expect(page).not_to have_link 'Messages'

          click_button 'Account menu'

          expect(page).not_to have_link 'Messages'

          click_link 'Site'
          click_link 'Messages'
        end

        expect(page).to have_content 'Messages'
        expect(current_path).to eq '/site/messages'
      end
    end
  end
end
