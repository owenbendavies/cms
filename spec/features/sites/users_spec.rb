require 'rails_helper'

RSpec.feature 'Site users' do
  let(:go_to_url) { '/site/users' }

  let(:admin_selector) { '.admin.fa-check' }
  let(:confirmed_selector) { '.confirmed.fa-check' }
  let(:locked_selector) { '.locked.fa-check' }

  include_examples 'restricted page with topbar link', 'Users'

  it_behaves_like 'logged in site user' do
    scenario 'visiting the page' do
      within 'thead' do
        expect(page).to have_content 'Name'
        expect(page).to have_content 'Email'
        expect(page).to have_content 'Confirmed'
        expect(page).to have_content 'Locked'
        expect(page).to have_content 'Admin'
      end

      within 'tbody tr:nth-child(1)' do
        expect(page).to have_content admin.name
        expect(page).to have_content admin.email
        expect(page).to have_selector confirmed_selector
        expect(page).to_not have_selector locked_selector
        expect(page).to have_selector admin_selector
      end

      within 'tbody tr:nth-child(2)' do
        expect(page).to have_content site_user.name
        expect(page).to have_content site_user.email
        expect(page).to have_selector confirmed_selector
        expect(page).to_not have_selector locked_selector
        expect(page).to_not have_selector admin_selector
      end
    end

    include_examples 'page with topbar link', 'Users', 'group'
  end

  context 'with unconfirmed user' do
    let(:unconfirmed_user) { FactoryGirl.create(:unconfirmed_user) }

    before do
      SiteSetting.create!(
        user: unconfirmed_user,
        site: site,
        created_by: admin,
        updated_by: admin
      )
    end

    it_behaves_like 'logged in admin' do
      scenario 'visiting the page' do
        within 'tbody tr:nth-child(2)' do
          expect(page).to have_content unconfirmed_user.name
          expect(page).to have_content unconfirmed_user.email
          expect(page).to_not have_selector confirmed_selector
        end
      end
    end
  end

  context 'with locked user' do
    let(:locked_user) { FactoryGirl.create(:locked_user) }

    before do
      SiteSetting.create!(
        user: locked_user,
        site: site,
        created_by: admin,
        updated_by: admin
      )
    end

    it_behaves_like 'logged in admin' do
      scenario 'visiting the page' do
        within 'tbody tr:nth-child(2)' do
          expect(page).to have_content locked_user.name
          expect(page).to have_content locked_user.email
          expect(page).to have_selector locked_selector
        end
      end
    end
  end
end
