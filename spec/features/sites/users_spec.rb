require 'rails_helper'

RSpec.feature 'Site users' do
  let(:go_to_url) { '/site/users' }

  let(:confirmed_selector) { '.confirmed.fa-check' }
  let(:locked_selector) { '.locked.fa-check' }

  authenticated_page topbar_link: 'Users', page_icon: 'group' do
    scenario 'visiting the page' do
      visit_200_page

      within 'thead' do
        expect(page).to have_content 'Name'
        expect(page).to have_content 'Email'
        expect(page).to have_content 'Confirmed'
        expect(page).to have_content 'Locked'
      end

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content site_user.name
        expect(page).to have_content site_user.email
        expect(page).to have_selector confirmed_selector
        expect(page).not_to have_selector locked_selector
      end
    end

    scenario 'with unconfirmed user' do
      unconfirmed_user = FactoryGirl.create(:unconfirmed_user)
      unconfirmed_user.site_settings.create!(site: site)
      visit_200_page
      index = site.users.find_index(unconfirmed_user)

      within "tbody tr:nth-child(#{index + 1})" do
        expect(page).to have_content unconfirmed_user.name
        expect(page).to have_content unconfirmed_user.email
        expect(page).not_to have_selector confirmed_selector
      end
    end

    scenario 'with locked user' do
      locked_user = FactoryGirl.create(:locked_user)
      locked_user.site_settings.create!(site: site)
      visit_200_page
      index = site.users.find_index(locked_user)

      within "tbody tr:nth-child(#{index + 1})" do
        expect(page).to have_content locked_user.name
        expect(page).to have_content locked_user.email
        expect(page).to have_selector locked_selector
      end
    end
  end
end
