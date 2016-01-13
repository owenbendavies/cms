require 'rails_helper'

RSpec.feature 'Topbar' do
  let(:go_to_url) { '/test_page' }

  scenario 'cannot use topbar' do
    visit_200_page go_to_url
    expect(page).to have_no_selector '#cms-topbar'
  end

  as_a 'logged in site user' do
    scenario 'while logged in' do
      within '#cms-topbar' do
        expect(page).to have_content site_user.name
      end
    end

    scenario 'navigating to home' do
      within '#cms-topbar' do
        click_link site.name
      end

      expect(current_path).to eq '/home'
    end

    scenario 'navigating to page via dropdowns', js: true do
      within '#cms-topbar' do
        expect(page).to_not have_link 'Toggle navigation'
        expect(page).to_not have_link 'Messages'

        click_link 'Site'
        click_link 'Messages'
      end

      expect(page).to have_content 'Messages'
      expect(current_path).to eq '/site/messages'
    end

    scenario 'navigating to page via dropdowns on mobile', js: true do
      windows.first.resize_to 640, 1136

      within '#cms-topbar' do
        expect(page).to_not have_link 'Site'
        expect(page).to_not have_link 'Messages'

        click_button 'Toggle navigation'

        expect(page).to_not have_link 'Messages'

        click_link 'Site'
        click_link 'Messages'
      end

      expect(page).to have_content 'Messages'
      expect(current_path).to eq '/site/messages'
    end
  end
end
