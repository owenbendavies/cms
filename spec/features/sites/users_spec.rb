require 'rails_helper'

RSpec.feature 'Site users' do
  let(:tick) { '.fas.fa-check.fa-fw' }

  before do
    login_as site_user
  end

  scenario 'list of users' do
    index = site.users.ordered.find_index(site_user)
    navigate_via_topbar menu: 'Site', title: 'Users', icon: '.fas.fa-users.fa-fw'

    expect(table_header_text).to eq %w[Name Email Admin Confirmed Locked]
    expect(table_rows.count).to eq site.users.count
    expect(table_rows[index][0].text).to eq site_user.name
    expect(table_rows[index][1].text).to eq site_user.email
    expect(table_rows[index][2]).not_to have_selector tick
    expect(table_rows[index][3]).to have_selector tick
    expect(table_rows[index][4]).not_to have_selector tick
  end

  scenario 'site admin' do
    index = site.users.ordered.find_index(site_admin)
    navigate_via_topbar menu: 'Site', title: 'Users', icon: '.fas.fa-users.fa-fw'

    expect(table_rows[index][2]).to have_selector tick
  end

  scenario 'unconfirmed user' do
    unconfirmed_user = FactoryBot.create(:user, :unconfirmed, site: site)
    index = site.users.ordered.find_index(unconfirmed_user)
    navigate_via_topbar menu: 'Site', title: 'Users', icon: '.fas.fa-users.fa-fw'

    expect(table_rows[index][3]).not_to have_selector tick
  end

  scenario 'locked user' do
    locked_user = FactoryBot.create(:user, :locked, site: site)
    index = site.users.ordered.find_index(locked_user)
    navigate_via_topbar menu: 'Site', title: 'Users', icon: '.fas.fa-users.fa-fw'

    expect(table_rows[index][4]).to have_selector tick
  end
end
