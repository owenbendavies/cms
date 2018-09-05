require 'rails_helper'

RSpec.feature 'Messages' do
  let!(:messages) do
    (0..11).map do |i|
      FactoryBot.create(
        :message,
        site: site,
        created_at: Time.zone.now - 1.month - 3.days - i.minutes,
        updated_at: Time.zone.now - 1.month - 3.days - i.minutes
      )
    end
  end

  before do
    FactoryBot.create(:message)
    login_as site_user
    navigate_via_topbar menu: 'Site', title: 'Messages', icon: 'svg.fa-envelope.fa-fw'
  end

  scenario 'list of messages' do
    expect(all(:react_table_rows).size).to eq 10

    within(:react_table_row, 1) do
      expect(find(:react_table_cell, 2).text).to eq messages.first.name
      expect(find(:react_table_cell, 3).text).to eq messages.first.email
      expect(find(:react_table_cell, 4).text).to eq messages.first.phone
      expect(find(:react_table_cell, 5).text).to eq messages.first.created_at.iso8601
    end
  end

  scenario 'expanding a row' do
    within(:react_table_row, 1) do
      expect(page).not_to have_content messages.first.message
      find(:react_table_cell, 1).click
      expect(page).to have_content messages.first.message
    end
  end

  scenario 'clicking pagination' do
    expect(page).to have_content messages.first.name
    expect(page).not_to have_content messages.last.name

    click_button 'Next'

    expect(page).not_to have_content messages.first.name
    expect(page).to have_content messages.last.name

    click_button 'Previous'

    expect(page).to have_content messages.first.name
    expect(page).not_to have_content messages.last.name
  end

  scenario 'changing number of rows' do
    find('.select-wrap select').select('5 rows')
    expect(all(:react_table_rows).size).to eq 5
  end
end
