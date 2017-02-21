# TODO: refactor

require 'rails_helper'

RSpec.feature 'Site users' do
  let(:go_to_url) { '/site/users' }

  let(:tick) { '.fa-check' }

  as_a 'authorized user', :site_user, 'Users', 'group' do
    scenario 'visiting the page' do
      FactoryGirl.create(:user).tap do |user|
        user.site_settings.create!(site: site)
      end

      visit_200_page

      index = site.users.ordered.find_index(site_user)

      expect(table_header_text).to eq %w(Name Email Admin Confirmed Locked)
      expect(table_rows.count).to eq site.users.count
      expect(table_rows[index][0].text).to eq site_user.name
      expect(table_rows[index][1].text).to eq site_user.email
      expect(table_rows[index][2]).not_to have_selector tick
      expect(table_rows[index][3]).to have_selector tick
      expect(table_rows[index][4]).not_to have_selector tick
    end

    scenario 'with site admin' do
      index = site.users.ordered.find_index(site_admin)

      visit_200_page

      expect(table_rows[index][2]).to have_selector tick
    end

    scenario 'with unconfirmed user' do
      unconfirmed_user = FactoryGirl.create(:user, :unconfirmed)
      unconfirmed_user.site_settings.create!(site: site)
      visit_200_page

      index = site.users.ordered.find_index(unconfirmed_user)

      expect(table_rows[index][3]).not_to have_selector tick
    end

    scenario 'with locked user' do
      locked_user = FactoryGirl.create(:user, :locked)
      locked_user.site_settings.create!(site: site)
      visit_200_page

      index = site.users.ordered.find_index(locked_user)

      expect(table_rows[index][4]).to have_selector tick
    end
  end
end
