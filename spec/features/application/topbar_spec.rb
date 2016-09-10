require 'rails_helper'

RSpec.feature 'Topbar' do
  let(:go_to_url) { '/home' }
  let(:topbar_selector) { '#cms-topbar' }
  let(:body_class) { '.cms-loggedin' }

  scenario 'cannot use topbar' do
    visit_200_page
    expect(page).to have_no_selector topbar_selector
    expect(page).to have_no_selector body_class
  end

  as_a 'authorized user' do
    scenario 'while logged in' do
      visit_200_page

      within topbar_selector do
        expect(page).to have_content site_user.name
      end

      expect(page).to have_selector body_class
    end

    scenario 'navigating to home' do
      visit_200_page

      within topbar_selector do
        click_link site.name
      end

      expect(current_path).to eq '/home'
    end

    scenario 'navigating to page via dropdowns', js: true do
      visit_200_page

      within topbar_selector do
        expect(page).not_to have_link 'Account menu'
        expect(page).not_to have_link 'Messages'

        click_link 'Site'
        click_link 'Messages'
      end

      expect(page).to have_content 'Messages'
      expect(current_path).to eq '/site/messages'
    end

    scenario 'navigating to page via dropdowns on mobile', js: true do
      visit_200_page

      windows.first.resize_to 640, 1136

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
